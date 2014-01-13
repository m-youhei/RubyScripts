# -*- coding: utf-8 -*-
require "rexml/document"

include REXML

targets = [ "Hoge", "Test" ]

doc = Document.new File.new("xml/index.xml")

targets.each do |trg|
  name = trg + ".txt"
  file = File.open(name, 'w')
  doc.elements.each("doxygenindex/compound") { |element, index| 
    if element.attributes["kind"] == "class"
      element.elements.each("name") { |ele|
        if ele.text == trg
          subDoc = Document.new File.new("xml/" + element.attributes["refid"] + ".xml")
          subDoc.elements.each("doxygen/compounddef") { |subElement|
            puts subElement.attributes["kind"]
            if subElement.attributes["kind"] == "class"
              @text
              subElement.elements.each("sectiondef/memberdef") { |memberdefElement|
                memberdefElement.elements.each("briefdescription/para") { |brief|
                  file.puts("// " + brief.text)
                }
                memberdefElement.elements.each("definition") { |definition|
                  @text = definition.text
                }
                memberdefElement.elements.each("argsstring") { |argsstring|
                  @text += argsstring.text
                }
                file.puts(@text)
                file.puts("{")
                file.puts("}")
                file.puts("")
              }
            end
          }
        end
      }
    end
  }
end
