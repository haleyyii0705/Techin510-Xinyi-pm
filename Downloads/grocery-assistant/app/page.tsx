import Link from "next/link"
import { ShoppingCart } from "lucide-react"
import { Button } from "@/components/ui/button"

export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center p-4">
      <div className="w-full max-w-md mx-auto space-y-8 mt-8">
        <div className="text-center space-y-2">
          <ShoppingCart className="h-12 w-12 mx-auto text-primary" />
          <h1 className="text-3xl font-bold">Smart Shopping Assistant</h1>
          <p className="text-muted-foreground">Recommends products based on your health needs and budget</p>
        </div>

        <div className="space-y-4 mt-8">
          <div className="bg-muted/50 p-4 rounded-lg space-y-2">
            <h2 className="font-medium">Key Features</h2>
            <ul className="space-y-2">
              <li className="flex items-start">
                <span className="bg-primary text-primary-foreground rounded-full h-5 w-5 flex items-center justify-center text-xs mr-2 mt-0.5">
                  1
                </span>
                <span>Personalized preferences (health needs, budget control)</span>
              </li>
              <li className="flex items-start">
                <span className="bg-primary text-primary-foreground rounded-full h-5 w-5 flex items-center justify-center text-xs mr-2 mt-0.5">
                  2
                </span>
                <span>Smart product recommendations that meet your requirements</span>
              </li>
              <li className="flex items-start">
                <span className="bg-primary text-primary-foreground rounded-full h-5 w-5 flex items-center justify-center text-xs mr-2 mt-0.5">
                  3
                </span>
                <span>Personal account management to save your shopping history</span>
              </li>
            </ul>
          </div>

          <div className="flex flex-col gap-2">
            <Link href="/dashboard" className="w-full">
              <Button className="w-full" size="lg">
                Get Started
              </Button>
            </Link>
          </div>
        </div>
      </div>
    </main>
  )
}
