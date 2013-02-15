# spec/mithril/parsers/parser_helpers_helper.rb

require 'mithril/parsers/parser_helpers'

shared_examples_for Mithril::Parsers::ParserHelpers do
  describe :preprocess_input do
    specify { expect(instance.respond_to? :preprocess_input, true).to be true }
    
    specify "strips leading and trailing whitespace" do
      clean, dirty = "lorem ipsum", "\n\tlorem ipsum    \r\r"
      expect(instance.send :preprocess_input, dirty).to eq clean
    end # specify
    
    specify "normalises internal whitespace" do
      clean, dirty = "lorem ipsum dolor sit amet", "lorem ipsum  \rdolor\n\tsit amet"
      expect(instance.send :preprocess_input, dirty).to eq clean
    end # specify
    
    specify "converts puntuation to whitespace" do
      clean, dirty = "lorem ipsum dolor sit amet", "lorem?-\"ipsum' :: (dolor![sit]), amet;"
      expect(instance.send :preprocess_input, dirty).to eq clean
    end # specify
  end # describe
  
  describe :wordify do
    specify { expect(instance.respond_to? :wordify, true).to be true }
    
    specify "splits input on whitespace" do
      output = %w(second star to the right and straight on till morning)
      expect(instance.send :wordify, output.join(" ")).to eq output
    end # specify
  end # describe
end # shared examples
