import { useState } from "react"
import { Rocket, Loader2 } from "lucide-react"
import { Card } from "./ui/Card"
import { Input } from "./ui/Input"
import { Button } from "./ui/Button"
import { Checkbox } from "./ui/Checkbox"
import type { Repository } from "../types"

interface StackCreatorProps {
  repositories: Repository[]
  onCreateStack: (branch: string, repos: string[], installDeps: boolean) => Promise<void>
  isLoading: boolean
}

export function StackCreator({ repositories, onCreateStack, isLoading }: StackCreatorProps) {
  const [branch, setBranch] = useState("")
  const [selectedRepos, setSelectedRepos] = useState<Set<string>>(new Set())
  const [installDeps, setInstallDeps] = useState(false)

  const toggleRepo = (repoName: string) => {
    const newSet = new Set(selectedRepos)
    if (newSet.has(repoName)) {
      newSet.delete(repoName)
    } else {
      newSet.add(repoName)
    }
    setSelectedRepos(newSet)
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!branch.trim() || selectedRepos.size === 0) return

    await onCreateStack(branch, Array.from(selectedRepos), installDeps)

    // Reset form
    setBranch("")
    setSelectedRepos(new Set())
    setInstallDeps(false)
  }

  const canSubmit = branch.trim() && selectedRepos.size > 0 && !isLoading

  return (
    <Card>
      <div className="flex items-center gap-2 mb-6">
        <Rocket className="h-5 w-5 text-blue-500" />
        <h2 className="text-lg font-semibold text-foreground">New Stack</h2>
      </div>

      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block text-sm font-medium text-gray-400 mb-2">
            Branch Name
          </label>
          <Input
            type="text"
            placeholder="e.g., feature/auth"
            value={branch}
            onChange={(e) => setBranch(e.target.value)}
            disabled={isLoading}
          />
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-400 mb-3">
            Repositories
          </label>
          <div className="space-y-2">
            {repositories.map((repo) => (
              <Checkbox
                key={repo.name}
                checked={selectedRepos.has(repo.name)}
                onCheckedChange={() => toggleRepo(repo.name)}
                label={`${repo.name} (port ${repo.basePort})`}
                disabled={isLoading}
              />
            ))}
          </div>
        </div>

        <div>
          <Checkbox
            checked={installDeps}
            onCheckedChange={setInstallDeps}
            label="Install dependencies"
            disabled={isLoading}
          />
        </div>

        <Button
          type="submit"
          disabled={!canSubmit}
          className="w-full"
        >
          {isLoading ? (
            <>
              <Loader2 className="mr-2 h-4 w-4 animate-spin" />
              Creating Stack...
            </>
          ) : (
            'Create Stack'
          )}
        </Button>
      </form>
    </Card>
  )
}
