/// Represents the distinct types of steps within a workflow process.
///
/// Each enum value signifies a specific phase or responsibility
/// within a structured workflow. Use these to categorize or control
/// the flow of multi-step operations, especially in prompt-based systems.
enum WorkflowStepType {
  /// Assess the current situation or objective to determine what needs to be done.
  assess,

  /// Perform research externally to gather information or explore solutions.
  ///
  /// This phase is optional—only performed if additional knowledge will add value.
  research,

  /// Enrich the current approach by incorporating project conventions and packages from the project.
  enrich,

  /// Align all progress and findings so far with user requirements and expectations.
  align,

  /// Refine the requirements and proposed solution, delving into greater specificity and detail.
  refine,

  /// Develop a detailed and actionable plan for implementing the refined solution.
  plan,

  /// Execute actions as described in the plan to achieve the defined objectives.
  act,

  /// Review the results for quality, completeness, and adherence to requirements.
  review,

  /// Test and verify the results in an end-to-end (E2E) manner to ensure correctness.
  test,

  /// Deliver the final results to the user or appropriate stakeholder.
  deliver,
}
