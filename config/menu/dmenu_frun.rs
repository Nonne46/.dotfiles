use std::env;
use std::collections::HashMap;
use std::fs::{self, File};
use std::io::{self, BufRead, BufReader, Write};
use std::os::unix::process::CommandExt;
use std::path::PathBuf;
use std::process::{Command, Stdio};

fn get_cache_path() -> io::Result<PathBuf> {
    let cache_dir = env::var("XDG_CACHE_HOME")
        .map(PathBuf::from)
        .unwrap_or_else(|_| {
            let home = env::var("HOME").expect("HOME environment variable not set");
            PathBuf::from(home).join(".cache")
        });
    Ok(cache_dir.join("dmenu_recent"))
}

fn is_valid_command(cmd: &str) -> bool {
    let paths = env::var("PATH").expect("bro, it seems you don't have PATH");
    for path in paths.split(":") {
        let cmd_path = format!("{}/{}", path, cmd);
        if fs::metadata(cmd_path).is_ok() {
            return true;
        }
    }
    false
}

fn read_cache(cache_path: &PathBuf) -> io::Result<HashMap<String, usize>> {
    if !cache_path.exists() {
        return Ok(HashMap::new());
    }

    let file = File::open(cache_path)?;
    let reader = BufReader::new(file);
    let mut commands: HashMap<String, usize> = HashMap::new();
    
    for line in reader.lines() {
        let cur_line = line?;
        if let Some((count, cmd)) = cur_line.split_once(" ") {
            if let Ok(count) = count.parse::<usize>() {
                let cmd = cmd.to_string();
                if !commands.contains_key(&cmd) && is_valid_command(&cmd) {
                    commands.insert(cmd, count);
                }
            }
        }
    }
    
    Ok(commands)
}

fn get_all_commands() -> io::Result<Vec<String>> {
    let output = Command::new("dmenu_path").output()?;
    String::from_utf8(output.stdout)
        .map(|s| s.lines().map(String::from).collect())
        .map_err(|e| io::Error::new(io::ErrorKind::InvalidData, e))
}

fn run_dmenu(items: &[String]) -> io::Result<Option<String>> {
    let input = items.join("\n");
    let mut child = Command::new("dmenu")
        .arg("-i")
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .spawn()?;

    if let Some(mut stdin) = child.stdin.take() {
        stdin.write_all(input.as_bytes())?;
    }

    let output = child.wait_with_output()?;
    if !output.status.success() {
        return Ok(None);
    }

    String::from_utf8(output.stdout)
        .map(|s| Some(s.trim().to_string()))
        .map_err(|e| io::Error::new(io::ErrorKind::InvalidData, e))
}

fn main() -> io::Result<()> {
    let cache_path = get_cache_path()?;
    let mut commands_freq = read_cache(&cache_path)?;
    
    let mut all_commands = get_all_commands()?;
    all_commands.sort_by(|a, b| {
        let b_count = commands_freq.get(b).unwrap_or(&0);
        let a_count = commands_freq.get(a).unwrap_or(&0);
        return b_count.cmp(&a_count);
    });

    let selected = match run_dmenu(&all_commands)? {
        Some(cmd) if !cmd.is_empty() => cmd,
        _ => return Ok(()),
    };

    *commands_freq.entry(selected.clone()).or_insert(0) += 1;

    let mut file = File::create(&cache_path)?;
    for (cmd, count) in commands_freq.iter().take(100) {
        writeln!(file, "{} {}", count, cmd)?;
    }

    let terminal = env::var("TERMINAL").unwrap_or_else(|_| "st".to_string());
    let error = if selected.ends_with(';') {
        let cmd_args: Vec<&str> = selected[..selected.len()-1].split(" ").collect();
        //cmd_args.insert(0, "-e");
        Command::new(&terminal)
            .args(&cmd_args)
            .exec()
    } else {
        Command::new(&selected)
            .exec()
    };

    Err(error)
}
