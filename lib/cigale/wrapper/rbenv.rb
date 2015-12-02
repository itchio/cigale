
module Cigale::Wrapper
  def translate_rbenv_wrapper (xml, wdef)
    xml.tag! "ruby-proxy-object" do
      xml.tag! "ruby-object", rbenvclass("Jenkins::Tasks::BuildWrapperProxy") do
        xml.pluginid "rbenv", rbenvclass("String")
        xml.object rbenvclass("RbenvWrapper") do
          xml.gem__list "bundler,rake", rbenvclass("String")
          xml.rbenv__root "$HOME/.rbenv", rbenvclass("String")
          xml.rbenv__repository "https://github.com/sstephenson/rbenv.git", rbenvclass("String")
          xml.rbenv__revision "master", rbenvclass("String")
          xml.ruby__build__repository "https://github.com/sstephenson/ruby-build.git", rbenvclass("String")
          xml.ruby__build__revision "master", rbenvclass("String")
          xml.version wdef["ruby-version"] || "1.9.3-p484", rbenvclass("String")
          xml.ignore__local__version (wdef["ignore-local-version"] == true ? rbenvclass("trueClass") : rbenvclass("falseClass"))
        end
      end
    end
  end

  def rbenvclass (clazz)
    return {
      :pluginid => "rbenv",
      :"ruby-class" => clazz,
    }
  end
end
