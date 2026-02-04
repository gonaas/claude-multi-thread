import { List, Loader2 } from "lucide-react"
import { Card } from "./ui/Card"
import { StackCard } from "./StackCard"
import type { StackInstance } from "../types"

interface ActiveStacksProps {
  stacks: StackInstance[]
  isLoading: boolean
  onRefresh: () => void
  onOpenStack: (stack: StackInstance) => Promise<void>
  onKillStack: (stackId: string) => Promise<void>
}

export function ActiveStacks({
  stacks,
  isLoading,
  onRefresh,
  onOpenStack,
  onKillStack
}: ActiveStacksProps) {
  return (
    <Card>
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-2">
          <List className="h-5 w-5 text-blue-500" />
          <h2 className="text-lg font-semibold text-foreground">Active Stacks</h2>
          <span className="text-sm text-gray-500">({stacks.length})</span>
        </div>
        <button
          onClick={onRefresh}
          disabled={isLoading}
          className="text-sm text-gray-400 hover:text-gray-300 transition-colors"
        >
          {isLoading ? <Loader2 className="h-4 w-4 animate-spin" /> : 'Refresh'}
        </button>
      </div>

      <div className="space-y-3 max-h-[600px] overflow-y-auto">
        {stacks.length === 0 ? (
          <div className="text-center py-12 text-gray-500">
            <p className="text-sm">No active stacks</p>
            <p className="text-xs mt-1">Create a new stack to get started</p>
          </div>
        ) : (
          stacks.map((stack) => (
            <StackCard
              key={stack.id}
              stack={stack}
              onOpen={() => onOpenStack(stack)}
              onKill={() => onKillStack(stack.id)}
            />
          ))
        )}
      </div>
    </Card>
  )
}
