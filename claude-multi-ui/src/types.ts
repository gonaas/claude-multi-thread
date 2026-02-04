export interface Repository {
  name: string;
  path: string;
  basePort: number;
}

export interface StackInstance {
  id: string;
  branch: string;
  instanceNumber: number;
  repositories: RepositoryInstance[];
  createdAt: string;
  tempDir: string;
}

export interface RepositoryInstance {
  name: string;
  port: number;
  path: string;
  symlink: string;
}

export interface CreateStackRequest {
  branch: string;
  repos: string[];
  installDeps: boolean;
}

export interface CommandResult {
  success: boolean;
  output: string;
  error?: string;
}

export interface RepositoryConfig {
  [key: string]: {
    path: string;
    basePort: number;
  };
}
