# spec/mithril/matchers/include_matching_spec.rb

require 'mithril/spec_helper'

describe "include matching matcher" do
  let :not_enumerable do Object.new; end
  let :empty_array    do []; end
  let :string_array   do %w(foo bar baz); end
  let :mixed_array    do [{}, String, "wibble", :wobble]; end
  
  specify { expect(not_enumerable).not_to include_matching(/foo/i) }
  
  specify { expect(empty_array).not_to include_matching(/foo/i) }
  
  specify { expect(string_array).to include_matching(/foo/i) }
  specify { expect(string_array).to include_matching(/bar/i) }
  specify { expect(string_array).to include_matching(/baz/i) }
  specify { expect(string_array).not_to include_matching(/wibble/i) }
  specify { expect(string_array).not_to include_matching(/wobble/i) }
  
  specify { expect(mixed_array).not_to include_matching(/foo/i) }
  specify { expect(mixed_array).to include_matching(/wibble/i) }
  specify { expect(mixed_array).to include_matching(/wobble/i) }
end # describe
