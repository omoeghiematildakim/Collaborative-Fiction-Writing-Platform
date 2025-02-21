import { describe, it, beforeEach, expect } from "vitest"

describe("Story Contract", () => {
  let mockStorage: Map<string, any>
  let storyIdNonce: number
  
  beforeEach(() => {
    mockStorage = new Map()
    storyIdNonce = 0
  })
  
  const mockContractCall = (method: string, args: any[], sender: string) => {
    switch (method) {
      case "create-story":
        const [title, content] = args
        storyIdNonce++
        mockStorage.set(`story-${storyIdNonce}`, {
          title,
          author: sender,
          content,
          created_at: Date.now(),
        })
        return { success: true, value: storyIdNonce }
      
      case "get-story":
        return { success: true, value: mockStorage.get(`story-${args[0]}`) }
      
      case "get-story-count":
        return { success: true, value: storyIdNonce }
      
      default:
        return { success: false, error: "Unknown method" }
    }
  }
  
  it("should create a story", () => {
    const result = mockContractCall("create-story", ["My Story", "Once upon a time..."], "user1")
    expect(result.success).toBe(true)
    expect(result.value).toBe(1)
  })
  
  it("should get a story", () => {
    mockContractCall("create-story", ["My Story", "Once upon a time..."], "user1")
    const result = mockContractCall("get-story", [1], "anyone")
    expect(result.success).toBe(true)
    expect(result.value).toEqual({
      title: "My Story",
      author: "user1",
      content: "Once upon a time...",
      created_at: expect.any(Number),
    })
  })
  
  it("should get story count", () => {
    mockContractCall("create-story", ["Story 1", "Content 1"], "user1")
    mockContractCall("create-story", ["Story 2", "Content 2"], "user2")
    const result = mockContractCall("get-story-count", [], "anyone")
    expect(result.success).toBe(true)
    expect(result.value).toBe(2)
  })
})

