"use client"

import { useState } from "react"
import Link from "next/link"
import { ArrowLeft, Save } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Label } from "@/components/ui/label"
import { Slider } from "@/components/ui/slider"
import { Switch } from "@/components/ui/switch"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"

export default function Preferences() {
  // Health preferences
  const [lowSugar, setLowSugar] = useState(false)
  const [lowSalt, setLowSalt] = useState(false)
  const [lowFat, setLowFat] = useState(false)
  const [organic, setOrganic] = useState(false)
  const [vegetarian, setVegetarian] = useState(false)

  // Budget control
  const [budget, setBudget] = useState(100)

  const handleSave = () => {
    // Save user preferences
    console.log("Saved preferences:", {
      healthPreferences: { lowSugar, lowSalt, lowFat, organic, vegetarian },
      budgetControl: { budget },
    })
  }

  return (
    <div className="flex min-h-screen flex-col p-4">
      <div className="flex items-center mb-6">
        <Link href="/dashboard" className="flex items-center text-sm text-muted-foreground">
          <ArrowLeft className="mr-2 h-4 w-4" />
          Back to Home
        </Link>
      </div>

      <div className="w-full max-w-md mx-auto space-y-6">
        <div className="text-center">
          <h1 className="text-2xl font-bold">Personal Preferences</h1>
          <p className="text-muted-foreground mt-2">Set your shopping preferences for more accurate recommendations</p>
        </div>

        <Tabs defaultValue="health" className="w-full">
          <TabsList className="grid w-full grid-cols-2">
            <TabsTrigger value="health">Health Needs</TabsTrigger>
            <TabsTrigger value="budget">Budget Control</TabsTrigger>
          </TabsList>

          <TabsContent value="health" className="space-y-4 mt-4">
            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <Label htmlFor="low-sugar" className="flex-1">
                  Low Sugar Foods
                </Label>
                <Switch id="low-sugar" checked={lowSugar} onCheckedChange={setLowSugar} />
              </div>

              <div className="flex items-center justify-between">
                <Label htmlFor="low-salt" className="flex-1">
                  Low Salt Foods
                </Label>
                <Switch id="low-salt" checked={lowSalt} onCheckedChange={setLowSalt} />
              </div>

              <div className="flex items-center justify-between">
                <Label htmlFor="low-fat" className="flex-1">
                  Low Fat Foods
                </Label>
                <Switch id="low-fat" checked={lowFat} onCheckedChange={setLowFat} />
              </div>

              <div className="flex items-center justify-between">
                <Label htmlFor="organic" className="flex-1">
                  Organic Foods
                </Label>
                <Switch id="organic" checked={organic} onCheckedChange={setOrganic} />
              </div>

              <div className="flex items-center justify-between">
                <Label htmlFor="vegetarian" className="flex-1">
                  Vegetarian
                </Label>
                <Switch id="vegetarian" checked={vegetarian} onCheckedChange={setVegetarian} />
              </div>
            </div>
          </TabsContent>

          <TabsContent value="budget" className="space-y-4 mt-4">
            <div className="space-y-4">
              <div className="space-y-2">
                <div className="flex items-center justify-between">
                  <Label>Weekly Shopping Budget</Label>
                  <span className="font-medium">${budget}</span>
                </div>
                <Slider value={[budget]} min={20} max={500} step={10} onValueChange={(value) => setBudget(value[0])} />
                <div className="flex justify-between text-xs text-muted-foreground">
                  <span>$20</span>
                  <span>$500</span>
                </div>
              </div>
            </div>
          </TabsContent>
        </Tabs>

        <Button onClick={handleSave} className="w-full" size="lg">
          <Save className="mr-2 h-4 w-4" />
          Save Preferences
        </Button>
      </div>
    </div>
  )
}
