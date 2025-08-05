require 'asciidoctor/extensions'
require 'prawn-svg'
Prawn::Svg::Font::GENERIC_CSS_FONT_MAPPING.merge!(
  'sans-serif' => 'Sans Serif',
  'M+ 1p' => 'M+ 1p Fallback'
)
