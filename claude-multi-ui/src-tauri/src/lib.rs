use serde::{Deserialize, Serialize};
use std::process::Command;
use std::fs;
use std::path::PathBuf;

#[derive(Debug, Serialize, Deserialize, Clone)]
struct Repository {
    name: String,
    path: String,
    #[serde(rename = "basePort")]
    base_port: u16,
}

#[derive(Debug, Serialize, Deserialize)]
struct RepositoryInstance {
    name: String,
    port: u16,
    path: String,
    symlink: String,
}

#[derive(Debug, Serialize, Deserialize)]
struct StackInstance {
    id: String,
    branch: String,
    #[serde(rename = "instanceNumber")]
    instance_number: u32,
    repositories: Vec<RepositoryInstance>,
    #[serde(rename = "createdAt")]
    created_at: String,
    #[serde(rename = "tempDir")]
    temp_dir: String,
}

fn get_home_dir() -> PathBuf {
    dirs::home_dir().expect("Could not find home directory")
}

fn get_config_path() -> PathBuf {
    get_home_dir()
        .join("dev")
        .join("claude-multi-thread")
        .join("config")
        .join("repos.conf")
}

#[tauri::command]
fn get_repositories() -> Result<Vec<Repository>, String> {
    let config_path = get_config_path();

    if !config_path.exists() {
        return Ok(vec![
            Repository {
                name: "nuela-next".to_string(),
                path: get_home_dir().join("dev").join("nuela-next").to_string_lossy().to_string(),
                base_port: 3000,
            },
            Repository {
                name: "nuela-apiv2".to_string(),
                path: get_home_dir().join("dev").join("nuela-apiv2").to_string_lossy().to_string(),
                base_port: 3003,
            },
            Repository {
                name: "nuela-ai".to_string(),
                path: get_home_dir().join("dev").join("nuela-ai").to_string_lossy().to_string(),
                base_port: 3001,
            },
        ]);
    }

    let content = fs::read_to_string(&config_path)
        .map_err(|e| format!("Failed to read config: {}", e))?;

    let mut repos = Vec::new();
    for line in content.lines() {
        if line.trim().is_empty() || line.trim().starts_with('#') {
            continue;
        }

        if line.contains("REPOS=(") || line.contains(')') {
            continue;
        }

        if let Some(start) = line.find('[') {
            if let Some(end) = line.find(']') {
                let name = &line[start + 2..end - 1];

                if let Some(eq_pos) = line.find('=') {
                    let value = &line[eq_pos + 2..line.len() - 1];
                    let parts: Vec<&str> = value.split(':').collect();

                    if parts.len() == 2 {
                        if let Ok(port) = parts[1].parse::<u16>() {
                            repos.push(Repository {
                                name: name.to_string(),
                                path: parts[0].replace("$HOME", &get_home_dir().to_string_lossy()),
                                base_port: port,
                            });
                        }
                    }
                }
            }
        }
    }

    if repos.is_empty() {
        return Ok(vec![
            Repository {
                name: "nuela-next".to_string(),
                path: get_home_dir().join("dev").join("nuela-next").to_string_lossy().to_string(),
                base_port: 3000,
            },
            Repository {
                name: "nuela-apiv2".to_string(),
                path: get_home_dir().join("dev").join("nuela-apiv2").to_string_lossy().to_string(),
                base_port: 3003,
            },
            Repository {
                name: "nuela-ai".to_string(),
                path: get_home_dir().join("dev").join("nuela-ai").to_string_lossy().to_string(),
                base_port: 3001,
            },
        ]);
    }

    Ok(repos)
}

#[tauri::command]
async fn create_stack(branch: String, repos: Vec<String>, install_deps: bool) -> Result<String, String> {
    let home = get_home_dir();
    let script_path = home.join("dev").join("claude-multi-thread").join("bin").join("claude-multi-start");

    let repos_arg = repos.join(",");
    let mut args = vec![branch.as_str(), "--repos", repos_arg.as_str()];

    if install_deps {
        args.push("--install-deps");
    }

    let output = Command::new("sh")
        .arg("-c")
        .arg(format!("source ~/.zshrc && {} {}", script_path.to_string_lossy(), args.join(" ")))
        .output()
        .map_err(|e| format!("Failed to execute command: {}", e))?;

    if !output.status.success() {
        let stderr = String::from_utf8_lossy(&output.stderr);
        return Err(format!("Command failed: {}", stderr));
    }

    Ok(String::from_utf8_lossy(&output.stdout).to_string())
}

#[tauri::command]
fn list_stacks() -> Result<Vec<StackInstance>, String> {
    let home = get_home_dir();
    let script_path = home.join("dev").join("claude-multi-thread").join("bin").join("claude-multi-list-stacks");

    let output = Command::new("sh")
        .arg("-c")
        .arg(format!("source ~/.zshrc && {}", script_path.to_string_lossy()))
        .output()
        .map_err(|e| format!("Failed to execute command: {}", e))?;

    if !output.status.success() {
        return Ok(Vec::new());
    }

    let stdout = String::from_utf8_lossy(&output.stdout);
    let mut stacks = Vec::new();

    for line in stdout.lines() {
        if line.trim().is_empty() || line.starts_with("Active") || line.starts_with("---") {
            continue;
        }

        let parts: Vec<&str> = line.split('|').map(|s| s.trim()).collect();
        if parts.len() >= 3 {
            let instance_num = parts[0].replace("Instance #", "").trim().parse::<u32>().unwrap_or(0);
            let branch = parts[1].to_string();
            let repos_str = parts[2];

            let repo_instances: Vec<RepositoryInstance> = repos_str
                .split(',')
                .map(|r| r.trim())
                .filter(|r| !r.is_empty())
                .enumerate()
                .map(|(i, name)| {
                    let base_port = match name {
                        "nuela-next" => 3000,
                        "nuela-apiv2" => 3003,
                        "nuela-ai" => 3001,
                        _ => 3000 + i as u16,
                    };

                    RepositoryInstance {
                        name: name.to_string(),
                        port: base_port + (instance_num as u16 * 1000),
                        path: format!("/tmp/claude-multi-stack-{}-{}/{}", instance_num, std::process::id(), name),
                        symlink: format!("{}/dev/{}-{}-i{}", home.to_string_lossy(), name, branch, instance_num),
                    }
                })
                .collect();

            stacks.push(StackInstance {
                id: format!("stack-{}-{}", instance_num, branch),
                branch: branch.clone(),
                instance_number: instance_num,
                repositories: repo_instances,
                created_at: chrono::Utc::now().to_rfc3339(),
                temp_dir: format!("/tmp/claude-multi-stack-{}-{}", instance_num, std::process::id()),
            });
        }
    }

    Ok(stacks)
}

#[tauri::command]
async fn open_stack(stack_id: String) -> Result<String, String> {
    Ok(format!("Opening stack {}", stack_id))
}

#[tauri::command]
async fn kill_stack(stack_id: String) -> Result<String, String> {
    let home = get_home_dir();
    let cleanup_script = home.join("dev").join("claude-multi-thread").join("bin").join("claude-multi-cleanup");

    Command::new("sh")
        .arg("-c")
        .arg(format!("source ~/.zshrc && {}", cleanup_script.to_string_lossy()))
        .output()
        .map_err(|e| format!("Failed to execute cleanup: {}", e))?;

    Ok(format!("Stack {} killed", stack_id))
}

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .plugin(tauri_plugin_opener::init())
        .invoke_handler(tauri::generate_handler![
            get_repositories,
            create_stack,
            list_stacks,
            open_stack,
            kill_stack
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
