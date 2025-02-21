import { describe, it, beforeEach, expect } from "vitest";

describe("Contribution Contract", () => {
  let mockStorage: Map<string, any>;
  let contributionIdNonce: number;
  
  beforeEach(() => {
    mockStorage = new Map();
    contributionIdNonce = 0;
  });
  
  const mockContractCall = (method: string, args: any[], sender: string) => {
    switch (method) {
      case "submit-contribution":
        const [storyId, content] = args;
        contributionIdNonce++;
        mockStorage.set(`contribution-${contributionIdNonce}`, {
          story_id: storyId,
          author: sender,
          content,
          status: "pending",
          created_at: Date.now(),
        });
        return { success: true, value: contributionIdNonce };
      
      case "get-contribution":
        return { success: true, value: mockStorage.get(`contribution-${args[0]}`) };
      
      case "get-contribution-count":
        return { success: true, value: contributionIdNonce };
      
      default:
        return { success: false, error: "Unknown method" };
    }
  };
  
  it("should submit a contribution", () => {
    const result = mockContractCall("submit-contribution", [1, "New content for the story"], "user1");
    expect(result.success).toBe(true);
    expect(result.value).toBe(1);
  });
  
  it("should get a contribution", () => {
    mockContractCall("submit-contribution", [1, "New content for the story"], "user1");
    const result = mockContractCall("get-contribution", [1], "anyone");
    expect(result.success).toBe(true);
    expect(result.value).toEqual({
      story_id: 1,
      author: "user1",
      content: "New content for the story",
      status: "pending",
      created_at: expect.any(Number),
    });
  });
  
  it("should get contribution count", () => {
    mockContractCall("submit-contribution", [1, "Contribution 1"], "user1");
    mockContractCall("submit-contribution", [1, "Contribution 2"], "user2");
    const result = mockContractCall("get-contribution-count", [], "anyone");
    expect(result.success).toBe(true);
    expect(result.value).toBe(2);
  });
});
