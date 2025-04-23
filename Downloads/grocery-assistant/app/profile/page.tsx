"use client"

import { useState } from "react"
import Link from "next/link"
import { ArrowLeft, User } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"

export default function Profile() {
  // Mock user data
  const [user, setUser] = useState({
    name: "John Smith",
    email: "john.smith@example.com",
    joinDate: "October 2023",
    avatar: "/placeholder.svg?height=100&width=100",
  })

  // Remove the handleLogout function
  // const handleLogout = () => {
  //   // Logout logic
  //   console.log("User logged out")
  // }

  return (
    <div className="flex min-h-screen flex-col p-4">
      <div className="flex items-center mb-6">
        <Link href="/dashboard" className="flex items-center text-sm text-muted-foreground">
          <ArrowLeft className="mr-2 h-4 w-4" />
          Back to Home
        </Link>
      </div>

      <div className="w-full max-w-md mx-auto space-y-6">
        <div className="flex flex-col items-center">
          <Avatar className="h-24 w-24">
            <AvatarImage src={user.avatar || "/placeholder.svg"} alt={user.name} />
            <AvatarFallback>
              <User className="h-12 w-12" />
            </AvatarFallback>
          </Avatar>
          <h1 className="text-2xl font-bold mt-4">{user.name}</h1>
          <p className="text-muted-foreground">{user.email}</p>
          <p className="text-sm text-muted-foreground">Joined: {user.joinDate}</p>
        </div>

        <Card>
          <CardHeader>
            <CardTitle>Account Information</CardTitle>
            <CardDescription>Manage your personal information and preferences</CardDescription>
          </CardHeader>
          <CardContent className="space-y-2">
            <Link href="/profile/edit" className="block">
              <Button variant="outline" className="w-full justify-start">
                Edit Profile
              </Button>
            </Link>
            <Link href="/preferences" className="block">
              Preferences
            </Link>
            <Link href="/purchase-history" className="block">
              Purchase History
            </Link>
          </CardContent>
        </Card>

        {/* Replace the bottom section with just navigation links */}
        <Card className="mt-6">
          <CardHeader>
            <CardTitle>Quick Links</CardTitle>
            <CardDescription>Navigate to other sections</CardDescription>
          </CardHeader>
          <CardContent className="space-y-2">
            <Link href="/dashboard" className="block">
              <Button variant="outline" className="w-full justify-start">
                Dashboard
              </Button>
            </Link>
            <Link href="/preferences" className="block">
              <Button variant="outline" className="w-full justify-start">
                Preferences
              </Button>
            </Link>
            <Link href="/purchase-history" className="block">
              <Button variant="outline" className="w-full justify-start">
                Purchase History
              </Button>
            </Link>
          </CardContent>
        </Card>

        {/* Remove the Separator and Logout button */}
      </div>
    </div>
  )
}
