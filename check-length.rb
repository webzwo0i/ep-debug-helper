pads={}
STDIN.readlines.each do |line|
  if m = line.match(/pad:(.[^:]*):revs:([0-9]+)[^{]*{"changeset":"Z:([a-z0-9]*)([<>])([0-9a-z]*)([^\$]*)/)
    name, rev, before, op, changed, csops = m[1..6]
    name = name.downcase
    pads[name] ||= {}

    if op == "<"
      newlength = before.to_i(36) - changed.to_i(36)
    end
    if op == ">"
      newlength = before.to_i(36) + changed.to_i(36)
    end
    rev=rev.to_i
    newlength = newlength.to_s(36)
    #puts "#{name}:#{rev} #{before}#{op}#{changed}:#{newlength}"

    if rev == 0
      pads[name][0] = [before,op,changed,csops,newlength]
    else
      if revbefore = pads[name][rev-1]
        if (l=revbefore.last) != before
          puts "#{name}:#{rev} #{before} is not #{l} (revaops:#{revbefore[3]} revbops:#{csops})"
        end
        pads[name].delete(rev-1)
      end
      pads[name][rev] = [before,op,changed,csops,newlength]
    end

  end
end
