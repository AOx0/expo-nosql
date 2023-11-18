//==============================================
// University of Bristol theme for Typst slides.
// Based on a previous version of David Barton's 
// UoB LaTeX Beamer template, found at
// https://github.com/dawbarton/UoB-beamer-theme
// =============================================

#import "../slides.typ": *

#let bristol-theme(
      color: rgb(171, 31, 45), watermark: "bristol/logo.png", logo: "", secondlogo: "bristol/secondlogo.svg"
   ) = data => {

    let title-slide(slide-info, bodies) = {

     	place(right, image(watermark, height:120%))

        v(5%)
	grid(columns: (1fr, 5%),
	    [],
	    // align(bottom + left)[#image(logo, width:40%)],
	    // align(bottom + right)[#image(secondlogo, width:40%)],
	    [])

        v(-10%)
        align(left + horizon)[
			#pad(left: 3em)[
	            #block(
	                stroke: ( y: 0mm + color ),
	                inset: 0em,
	                breakable: false,
	                [
	                    #text(1.3em, color)[*#data.title*] \
						#v(-2.5em)\
	                    #{
	                        if data.subtitle != none {
	                            parbreak()
	                            text(.9em, color)[#data.subtitle]
	                        }
	                    }
	                ]
	            )
	            #set text(size: .8em)
	            #grid(
	                columns: (1fr,) * calc.min(data.authors.len(), 3),
	                column-gutter: 1em,
	                row-gutter: 1em,
	                ..data.authors
	            )
	            #v(1em)
	            #data.date
			]
        ]
    }

    let default(slide-info, bodies) = {
        let body = none
        if bodies.len() == 1 {
	    body = bodies.first()
	}
	else{
	    let colwidths = none
	    let thisgutter = .2em
	    if "colwidths" in slide-info{
	        colwidths = slide-info.colwidths
		if colwidths.len() != bodies.len(){
		    panic("Provided colwidths must be of same length as bodies")
		}
	    }
	    else{
	        colwidths = (1fr,) * bodies.len()
	    }
	    if "gutter" in slide-info{
	        thisgutter = slide-info.gutter
            }
	    body = grid(
	        columns: colwidths,
		gutter: thisgutter,
		 ..bodies
	    )
	}

        let decoration(position, body) = {
            let border = 1mm + color
            let strokes = (
                header: ( bottom: border ),
                footer: ( top: border )
            )
	    grid(columns: (3%, 94%, 3%), [],
		block(
		    // stroke: strokes.at(position),
		    width: 100%,
		    inset: (x:.5em, y:.7em),
		    body
		),
	    [])
        }


        // header
        	decoration("header", grid(columns: (1fr),
		        	align(right, grid(rows: (.5em, .5em),
		        	// text(color, .7em)[#data.short-title],
					// [],
		        	text(color, .7em)[#section.display()]
			)
		)
		)
		)

        if "title" in slide-info {
            block(
                width: 100%, inset: (x: 4.5%, y: -.5em), breakable: false,
                outset: 0em,
                heading(level: 1, text(color)[#slide-info.title])
            )
	    v(.7em)
        }
        
        v(1fr)
        block(
            width: 100%, inset: (x: 2em), breakable: false, outset: 0em,
            body
        )
        v(2fr)

        // footer
        decoration("footer")[
            #h(1fr)
            #text(color, .6em)[#logical-slide.display()]
        ]
    }

    let wake-up(slide-info, bodies) = {
        if bodies.len() != 1 {
            panic("wake up variant of bristol theme only supports one body per slide")
        }
        let body = bodies.first()

        block(
            width: 100%, height: 100%, inset: 2em, breakable: false, outset: 0em,
            fill: color,
            text(size: 1.5em, fill: white, {v(1fr); body; v(1fr)})
        )
    }

    (
        "title slide": title-slide, "default": default, "wake up": wake-up,
    )
}
