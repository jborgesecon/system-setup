{ config, pkgs, ... }:

let
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) 
      # Core LaTeX distributions and collections
      scheme-basic                  # Basic LaTeX packages and core functionality
      collection-langcjk            # Support for Chinese, Japanese, and Korean languages
      collection-latexrecommended   # Recommended LaTeX packages for general use

      # Math and symbols
      amsmath      # Enhanced math environments and commands
      # amssymb      # Additional mathematical symbols and fonts

      # Text formatting and fonts
      newtx        # Modern Times-like fonts for text and math
      ulem         # Underline and strikethrough text formatting
      xstring      # Extended string manipulation macros

      # Page layout and geometry
      geometry     # Control page dimensions and margins

      # Graphics and figures
      graphics     # Include and manipulate graphics/images
      wrapfig      # Wrap text around figures

      # Tables and data presentation
      booktabs     # Professional-quality tables with better spacing
      capt-of      # Caption commands for use outside float environments

      # Cross-references and navigation
      hyperref     # Hyperlinks and PDF bookmarks
      tocbibind    # Add bibliography and index to table of contents

      # Footnotes and citations
      footmisc     # Customize footnote formatting and behavior

      # Document conversion and export
      dvipng       # Convert DVI to PNG for web/preview use
      dvisvgm      # Convert DVI to SVG for web/preview use

      # Development and testing
      lipsum       # Generate Lorem Ipsum placeholder text
    ;
  });

in
{
  home.packages = with pkgs; [
    tex
  ];
}