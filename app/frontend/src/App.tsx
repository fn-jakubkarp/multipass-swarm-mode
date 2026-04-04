import { useEffect, useState } from "react"
import { Button } from "@/components/ui/button"

export function App() {
  const [clicks, setClicks] = useState<number | null>(null)

  useEffect(() => {
    fetch("/api/clicks")
      .then((res) => res.json())
      .then((data) => setClicks(data.clicks))
  }, [])

  function handleClick() {
    fetch("/api/clicks/increment", { method: "POST" })
      .then((res) => res.json())
      .then((data) => setClicks(data.clicks))
  }

  return (
    <div className="flex min-h-svh items-center justify-center">
      <div className="flex flex-col items-center gap-4">
        <p className="text-4xl font-medium">{clicks ?? "—"}</p>
        <Button onClick={handleClick}>Click me</Button>
      </div>
    </div>
  )
}

export default App
