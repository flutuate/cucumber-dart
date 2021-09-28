class Calc {
  int lastResult;

  Calc() : lastResult = 0;

  void clear() => lastResult = 0;

  void sum(int param1, int param2) => lastResult = param1+param2;
}
