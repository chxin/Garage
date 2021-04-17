set tmpdir $::env(PATH)
puts $tmpdir

# Auto added signals
set filterKeyword "q"
set filterCondition ","
set minTime "1ms"
set maxTime "1s"

set monitorSignals [list]
set index -1
set nfacs [ gtkwave::getNumFacs ]

# Ditch all signals
gtkwave::/Edit/Highlight_All
gtkwave::/Edit/Delete
gtkwave::setFromEntry $minTime
gtkwave::setToEntry $maxTime
gtkwave::/Time/Zoom/Zoom_Best_Fit

# Set auto added signals
# from the signal name contain $filterKeyword
for {set i 0} {$i < $nfacs } {incr i} {
    set facname [ gtkwave::getFacName $i ]
    set index [ string first $filterKeyword $facname  ]
    set index2 [ string first $filterCondition $facname  ]

    if {$index != -1 && $index2 == -1} {
        lappend monitorSignals "$facname"
    }
}

# Add specific signals in $filter
set filter [list test_bench.clk test_bench.q\[3:0\] ]
gtkwave::addSignalsFromList $filter
gtkwave::addSignalsFromList $monitorSignals

# Convert monitor signals
gtkwave::highlightSignalsFromList $monitorSignals
gtkwave::highlightSignalsFromList $filter
gtkwave::/Edit/Data_Format/Decimal
gtkwave::/Edit/UnHighlight_All

# expand specific signals
# gtkwave::highlightSignalsFromList "msp430.port_out5\[7:0\]"
# gtkwave::/Edit/Expand
# gtkwave::deleteSignalsFromList [list msp430.port_out5\[3\] msp430.port_out5\[7\]]
# gtkwave::highlightSignalsFromList "msp430.intr_num\[7:0\]"
# gtkwave::/Edit/Expand
# gtkwave::deleteSignalsFromList [list msp430.intr_num\[7\] msp430.intr_num\[6\] msp430.intr_num\[5\] msp430.intr_num\[4\] msp430.intr_num\[3\] msp430.intr_num\[2\] msp430.intr_num\[0\]]

# introduce blanks
# gtkwave::highlightSignalsFromList "led.red"
# gtkwave::/Edit/Insert_Blank
# gtkwave::highlightSignalsFromList "msp430.intr_num\[1\]"
# gtkwave::/Edit/Insert_Blank
# gtkwave::/Edit/UnHighlight_All
# gtkwave::unhighlightSignalsFromList "led.red msp430.intr_num\[1\]"
