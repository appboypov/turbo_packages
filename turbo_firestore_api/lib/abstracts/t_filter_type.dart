abstract interface class TFilterType<VALUE> {
  bool filter<INPUT>({required VALUE value, INPUT? input});
}
