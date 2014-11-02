module Sift3Distance

  def sift_3_distance s1, s2
    #My version of the the sift3 algorithm re-written in ruby
    # sift3: http://siderite.blogspot.com/2007/04/super-fast-and-accurate-string-distance.html
    if s1.nil? || s1.length == 0
      if s2.nil? || s2.length == 0
        return 0;
      else
        return s2.length
      end
    end

    return s1.length if s2.nil? || s2.length == 0

    c = 0
    offset1 = 0
    offset2 = 0
    lcs = 0
    max_offset = 5

    begin
      if s1[c + offset1] == s2[c + offset2]
        lcs+= 1
      else
        offset1 = 0
        offset2 = 0
        max_offset.times do |i|
          if (c+i < s1.length) && (s1[c+i] == s2[c])
            offset1 = i
            break
          end
          if (c+i < s2.length) && (s1[c] == s2[c+i])
            offset2 = i
            break
          end
        end
      end
      c+= 1
    end while c+offset1 < s1.length && c+offset2 < s2.length

    (s1.length + s2.length)/2 - lcs
  end

  def self.included(base)
    base.extend(Sift3Distance)
  end
end
