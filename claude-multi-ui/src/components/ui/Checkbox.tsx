import { Check } from "lucide-react"
import { cn } from "../../lib/utils"

interface CheckboxProps {
  checked: boolean
  onCheckedChange: (checked: boolean) => void
  label: string
  disabled?: boolean
}

export function Checkbox({ checked, onCheckedChange, label, disabled }: CheckboxProps) {
  return (
    <label className={cn(
      "flex items-center space-x-3 cursor-pointer select-none",
      disabled && "opacity-50 cursor-not-allowed"
    )}>
      <div
        className={cn(
          "flex h-5 w-5 items-center justify-center rounded border-2 transition-colors",
          checked ? "bg-blue-600 border-blue-600" : "border-gray-600",
          !disabled && "hover:border-blue-500"
        )}
        onClick={() => !disabled && onCheckedChange(!checked)}
      >
        {checked && <Check className="h-3 w-3 text-white" />}
      </div>
      <span className="text-sm text-foreground">{label}</span>
    </label>
  )
}
