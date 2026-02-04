import { GitBranch, ExternalLink, Trash2, Server } from "lucide-react"
import { Button } from "./ui/Button"
import { formatTimestamp } from "../lib/utils"
import type { StackInstance } from "../types"

interface StackCardProps {
  stack: StackInstance
  onOpen: () => void
  onKill: () => void
}

export function StackCard({ stack, onOpen, onKill }: StackCardProps) {
  return (
    <div className="border border-border rounded-lg p-4 hover:border-gray-600 transition-colors">
      <div className="flex items-start justify-between mb-3">
        <div className="flex-1">
          <div className="flex items-center gap-2 mb-1">
            <GitBranch className="h-4 w-4 text-blue-500" />
            <h3 className="font-medium text-foreground">{stack.branch}</h3>
            <span className="text-xs bg-gray-800 px-2 py-0.5 rounded">
              Instance #{stack.instanceNumber}
            </span>
          </div>
          <p className="text-xs text-gray-500">{formatTimestamp(stack.createdAt)}</p>
        </div>
      </div>

      <div className="space-y-2 mb-3">
        {stack.repositories.map((repo) => (
          <div
            key={repo.name}
            className="flex items-center gap-2 text-sm"
          >
            <Server className="h-3 w-3 text-gray-500" />
            <span className="text-gray-300">{repo.name}</span>
            <span className="text-gray-600">:</span>
            <span className="text-blue-400 font-mono text-xs">{repo.port}</span>
          </div>
        ))}
      </div>

      <div className="flex gap-2">
        <Button
          size="sm"
          onClick={onOpen}
          className="flex-1"
        >
          <ExternalLink className="h-3 w-3 mr-1" />
          Open
        </Button>
        <Button
          size="sm"
          variant="danger"
          onClick={onKill}
        >
          <Trash2 className="h-3 w-3" />
        </Button>
      </div>
    </div>
  )
}
