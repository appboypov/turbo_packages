abstract interface class IFilter<MODEL> {
  bool filter<INPUT>({required MODEL model, INPUT? input});
}
