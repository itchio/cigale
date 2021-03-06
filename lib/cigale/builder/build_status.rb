
module Cigale::Builder

  def translate_build_status (xml, status, write_complete_build=true)
    @build_statuses ||= {
      "SUCCESS" => {
        "ordinal" => 0,
        "color" => "BLUE",
        "completeBuild" => true,
      },
      "UNSTABLE" => {
        "ordinal" => 1,
        "color" => "YELLOW",
        "completeBuild" => true,
      },
      "FAILURE" => {
        "ordinal" => 2,
        "color" => "RED",
        "completeBuild" => true,
      },
      "NOT_BUILD" => {
        "ordinal" => 3,
        "color" => "NOTBUILD",
        "completeBuild" => false,
      },
      "ABORTED" => {
        "ordinal" => 4,
        "color" => "ABORTED",
        "completeBuild" => false,
      },
    }

    spec = @build_statuses[status] or raise "Unknown build status: '#{status}'"
    xml.name status
    for k, v in spec
      next if (k == "completeBuild" && !write_complete_build)
      xml.tag! k, v
    end
  end

end
