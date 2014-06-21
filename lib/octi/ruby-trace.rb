module Trace

### This module supplies methods for tracing blocks of code ("blocks"
### in the informal sense "lines of code").  When the code is entered 
### and exited, message is printed.
### 
### How to use: 'include' this module in any class with a chunk of code 
### to be traced.  Suppose there is a code chunk
### 
###      -------
###        ------
###      -------
### 
###      Use a text editor to rewrite this as
### 
###      traceAround(label,
###                  ->(){NNNNNN},
###                  ->(){
###      -------
###        ------
###      -------
###                  },
###                  ->(v){XXXXX})
### 
### where NNNNN computes a string to printy on entry and XXXXX computes a string
### to print on exit, where v is the value of the code chunk, if any.  The first
### argument, 'label', is a symbol used to identify this trace.  You have to call
### traceOn(label) to turn it on; traceOff(label) deactivates it.  
### 
### Often, the chunk is the entire body of a method and the label is the same as 
### the name of the method.
### 
### The entry string is preceded by ">> " and the exit string by "<< ".  
### Furthermore, it is indented by 3 spaces for each level of tracing that is
### entered.  This makes it easier to figure out which exits correspond to
### which entrances.
### 
### You can turn off all tracing by doing setTraceActive(false), and turn it back
### on again with setTraceActive(true).
### 
### See ruby-trace-demo.rb to see examples.

  TRACE_INDENT = 3

  @@trace_depth = 0

  @@trace_active = true

  @@traced_labels = []

  def Trace.getDepth()
     return @@trace_depth
  end

  def Trace.setDepth(x)
     @@trace_depth = x
  end

  def traceOn(*labels)
    labels.each do |label|
      if !(@@traced_labels.include?(label))
        @@traced_labels.push(label)
      end
    end
  end

  def traceOff(*labels)
    labels.each do |label|
      @@traced_labels.delete(label)
    end
  end

  def getTraceActive()
    @@trace_active
  end

  def setTraceActive(v)
    if v == nil 
      @@trace_active = !@@trace_active
    else
      @@trace_active = v
    end
  end

  def traceAround(label, inS, doit, outS)
    do_trace = @@trace_active && @@traced_labels.include?(label)
    begin
      abnormal = true
      if do_trace
        indent = @@trace_depth * TRACE_INDENT
        puts stringIndent(">> " + inS.(), indent)
        @@trace_depth += 1
      end
      val = doit.()
      if do_trace
        puts stringIndent("<< " + outS.(val), indent)
        abnormal = false
      end
    ensure
      if do_trace
        @@trace_depth -= 1
        if abnormal
          puts(stringIndent("Execution aborted", indent))
        end
      end
    end
    return val
  end

  # From http://makandracards.com/makandra/6087-ruby-indent-a-string
  def Trace.stringIndent(str, count, char = ' ')
    str.gsub(/([^\n]*)(\n|$)/) do |match|
      last_iteration = ($1 == "" && $2 == "")
      line = ""
      line << (char * count) unless last_iteration
      line << $1
      line << $2
      line
    end

  end

end
