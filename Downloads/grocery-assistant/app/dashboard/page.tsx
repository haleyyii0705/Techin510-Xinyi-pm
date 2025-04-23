"use client"

import { useState } from "react"
import Link from "next/link"
import { Search, User, ShoppingBag, Heart, Settings } from "lucide-react"
import { Input } from "@/components/ui/input"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"

// Mock product data
const PRODUCTS = [
  {
    id: 1,
    name: "Organic Fresh Milk",
    price: 4.99,
    image: "/placeholder.svg?height=80&width=80",
    tags: ["Organic", "Low-fat"],
    match: 95,
  },
  {
    id: 2,
    name: "Whole Wheat Bread",
    price: 3.5,
    image: "/placeholder.svg?height=80&width=80",
    tags: ["Whole grain", "Low sugar"],
    match: 90,
  },
  {
    id: 3,
    name: "Fresh Vegetable Salad",
    price: 5.25,
    image: "/placeholder.svg?height=80&width=80",
    tags: ["Organic", "Vegetarian"],
    match: 85,
  },
  {
    id: 4,
    name: "Low-fat Yogurt",
    price: 2.99,
    image: "/placeholder.svg?height=80&width=80",
    tags: ["Low-fat", "Low sugar"],
    match: 80,
  },
]

export default function Dashboard() {
  const [searchQuery, setSearchQuery] = useState("")
  const [products, setProducts] = useState(PRODUCTS)

  const handleSearch = (e) => {
    e.preventDefault()
    // Simulate search functionality
    if (searchQuery.trim() === "") {
      setProducts(PRODUCTS)
    } else {
      const filtered = PRODUCTS.filter((product) => product.name.toLowerCase().includes(searchQuery.toLowerCase()))
      setProducts(filtered)
    }
  }

  return (
    <div className="flex min-h-screen flex-col">
      <header className="border-b p-4">
        <div className="flex items-center justify-between">
          <h1 className="text-xl font-bold">Smart Shopping Assistant</h1>
          <Link href="/profile">
            <Button variant="ghost" size="icon">
              <User className="h-5 w-5" />
            </Button>
          </Link>
        </div>

        <form onSubmit={handleSearch} className="mt-4 flex gap-2">
          <Input
            placeholder="Search products..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="flex-1"
          />
          <Button type="submit" size="icon">
            <Search className="h-4 w-4" />
          </Button>
        </form>
      </header>

      <main className="flex-1 p-4">
        <div className="mb-6">
          <h2 className="text-lg font-medium mb-3">Recommended for You</h2>
          <div className="space-y-4">
            {products.map((product) => (
              <Card key={product.id}>
                <CardContent className="p-3">
                  <div className="flex items-center gap-3">
                    <div className="relative">
                      <img
                        src={product.image || "/placeholder.svg"}
                        alt={product.name}
                        className="w-20 h-20 object-cover rounded-md"
                      />
                      <Badge className="absolute -top-2 -right-2 bg-primary">{product.match}% Match</Badge>
                    </div>
                    <div className="flex-1">
                      <h3 className="font-medium">{product.name}</h3>
                      <p className="text-primary font-bold">${product.price}</p>
                      <div className="flex flex-wrap gap-1 mt-1">
                        {product.tags.map((tag) => (
                          <Badge key={tag} variant="outline" className="text-xs">
                            {tag}
                          </Badge>
                        ))}
                      </div>
                    </div>
                    <Button variant="ghost" size="icon">
                      <Heart className="h-5 w-5" />
                    </Button>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      </main>

      <footer className="border-t">
        <div className="grid grid-cols-3 h-16">
          <Link href="/dashboard" className="flex flex-col items-center justify-center text-primary">
            <ShoppingBag className="h-5 w-5" />
            <span className="text-xs mt-1">Products</span>
          </Link>
          <Link href="/favorites" className="flex flex-col items-center justify-center text-muted-foreground">
            <Heart className="h-5 w-5" />
            <span className="text-xs mt-1">Favorites</span>
          </Link>
          <Link href="/preferences" className="flex flex-col items-center justify-center text-muted-foreground">
            <Settings className="h-5 w-5" />
            <span className="text-xs mt-1">Settings</span>
          </Link>
        </div>
      </footer>
    </div>
  )
}
