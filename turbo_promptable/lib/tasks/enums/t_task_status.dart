/// Workflow state of a local task, matching the Linear issue states.
enum TTaskStatus {
  inbox,
  backlog,
  pending,
  ready,
  inProgress,
  done,
  verified,
  canceled,
  duplicate,
}
