module Cigale::Publisher
  def translate_coverage_publisher (xml, pdef)
    translate_cobertura_publisher xml, {
      "report-file" => "**/coverage.xml",
      "only-stable" => false,
      "targets" => [
        {
          "conditional" => {
            "healthy" => 70,
            "unhealthy" => 0,
            "failing" => 0,
          },
        },
        {
          "line" => {
            "healthy" => 80,
            "unhealthy" => 0,
            "failing" => 0,
          },
        },
        {
          "method" => {
            "healthy" => 80,
            "unhealthy" => 0,
            "failing" => 0,
          },
        },
      ],
      "source-encoding" => "ASCII",
    }
  end
end
