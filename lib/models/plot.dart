class Plot {
  static const List<String> names = ['weight', 'sys', 'dia'];
  final DateTime xAxis;
  final double yAxis;
  final double yAxis2;
  Plot({this.xAxis, this.yAxis, this.yAxis2});

  String getName(int index) {
    return names[index];
  }

  @override
  String toString() {
    return 'xAxis: $xAxis, yAxis: $yAxis, yAxis2: $yAxis2';
  }
}
