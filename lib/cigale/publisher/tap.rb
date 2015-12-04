module Cigale::Publisher
  def translate_tap_publisher (xml, pdef)
    xml.testResults pdef["results"]
    xml.failIfNoResults false
    xml.failedTestsMarkBuildAsFailure false
    xml.outputTapToConsole true
    xml.enableSubtests true
    xml.discardOldReports false
    xml.todoIsFailure pdef["todo-is-failure"]
  end
end
