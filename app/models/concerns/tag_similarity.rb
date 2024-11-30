module TagSimilarity
    def tag_similarity(tags1, tags2)
      intersection = (tags1 & tags2).size
      union = (tags1 | tags2).size
      return 0 if union.zero?
  
      (intersection.to_f / union * 100).round(2)
    end
  end