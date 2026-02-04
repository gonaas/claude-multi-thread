import { useEffect, useState } from "react"
import { invoke } from "@tauri-apps/api/core"
import { StackCreator } from "./components/StackCreator"
import { ActiveStacks } from "./components/ActiveStacks"
import type { Repository, StackInstance } from "./types"

function App() {
  const [repositories, setRepositories] = useState<Repository[]>([])
  const [stacks, setStacks] = useState<StackInstance[]>([])
  const [isLoading, setIsLoading] = useState(false)
  const [isLoadingStacks, setIsLoadingStacks] = useState(false)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    loadRepositories().catch(err => {
      console.error("Failed to load repositories:", err)
      setError(err.toString())
    })
    loadStacks().catch(err => {
      console.error("Failed to load stacks:", err)
    })
  }, [])

  const loadRepositories = async () => {
    try {
      const repos = await invoke<Repository[]>("get_repositories")
      setRepositories(repos)
    } catch (error) {
      console.error("Failed to load repositories:", error)
    }
  }

  const loadStacks = async () => {
    setIsLoadingStacks(true)
    try {
      const activeStacks = await invoke<StackInstance[]>("list_stacks")
      setStacks(activeStacks)
    } catch (error) {
      console.error("Failed to load stacks:", error)
    } finally {
      setIsLoadingStacks(false)
    }
  }

  const handleCreateStack = async (
    branch: string,
    repos: string[],
    installDeps: boolean
  ) => {
    setIsLoading(true)
    try {
      await invoke("create_stack", {
        branch,
        repos,
        installDeps
      })
      await loadStacks()
    } catch (error) {
      console.error("Failed to create stack:", error)
      alert(`Failed to create stack: ${error}`)
    } finally {
      setIsLoading(false)
    }
  }

  const handleOpenStack = async (stack: StackInstance) => {
    try {
      await invoke("open_stack", { stackId: stack.id })
    } catch (error) {
      console.error("Failed to open stack:", error)
      alert(`Failed to open stack: ${error}`)
    }
  }

  const handleKillStack = async (stackId: string) => {
    if (!confirm("Are you sure you want to kill this stack?")) return

    try {
      await invoke("kill_stack", { stackId })
      await loadStacks()
    } catch (error) {
      console.error("Failed to kill stack:", error)
      alert(`Failed to kill stack: ${error}`)
    }
  }

  console.log("App rendering, repos:", repositories.length, "stacks:", stacks.length)

  if (error) {
    return (
      <div style={{ padding: "20px", background: "#1a1a1a", color: "#fff", minHeight: "100vh" }}>
        <h1>Error Loading App</h1>
        <pre>{error}</pre>
      </div>
    )
  }

  return (
    <div className="h-screen bg-background text-foreground flex flex-col">
      <header className="border-b border-border px-6 py-4">
        <h1 className="text-xl font-semibold">Claude Multi-Thread</h1>
        <p className="text-sm text-gray-500 mt-1">
          Manage multiple repository stacks across different branches
        </p>
      </header>

      <main className="flex-1 overflow-hidden">
        <div className="h-full grid grid-cols-2 gap-6 p-6">
          <div className="overflow-y-auto">
            <StackCreator
              repositories={repositories}
              onCreateStack={handleCreateStack}
              isLoading={isLoading}
            />
          </div>

          <div className="overflow-y-auto">
            <ActiveStacks
              stacks={stacks}
              isLoading={isLoadingStacks}
              onRefresh={loadStacks}
              onOpenStack={handleOpenStack}
              onKillStack={handleKillStack}
            />
          </div>
        </div>
      </main>
    </div>
  )
}

export default App
