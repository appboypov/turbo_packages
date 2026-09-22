/// Workflow state of a Linear issue, in board order.
enum TLinearIssueStatus {
  inbox('Inbox'),
  backlog('Backlog'),
  pending('Pending'),
  ready('Ready'),
  inProgress('In Progress'),
  done('Done'),
  verified('Verified'),
  canceled('Canceled'),
  duplicate('Duplicate')
  ;

  const TLinearIssueStatus(this.linearName);

  /// State name as Linear shows it.
  final String linearName;
}
