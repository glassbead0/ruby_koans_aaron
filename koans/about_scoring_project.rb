require File.expand_path(File.dirname(__FILE__) + '/neo')

# Greed is a dice game where you roll up to five dice to accumulate
# points.  The following "score" function will be used to calculate the
# score of a single roll of the dice.
#
# A greed roll is scored as follows:
#
# * A set of three ones is 1000 points
#
# * A set of three numbers (other than ones) is worth 100 times the
#   number. (e.g. three fives is 500 points).
#
# * A one (that is not part of a set of three) is worth 100 points.
#
# * A five (that is not part of a set of three) is worth 50 points.
#
# * Everything else is worth 0 points.
#
#
# Examples:
#
# score([1,1,1,5,1]) => 1150 points
# score([2,3,4,6,2]) => 0 points
# score([3,4,5,3,3]) => 350 points
# score([1,5,1,2,4]) => 250 points
#
# More scoring examples are given in the tests below:
#
# Your goal is to write the score method.

class Greed
  def initialize(dice)
    @dice = dice.sort
    @score = 0
  end

  def score
    num = 1
    while @dice.length > 0
      if num == 1
        score_ones

      elsif num == 5
        score_fives

      else # if num == 2, 3, 4, or 6
        score_others(num)
      end
      num += 1
    end
    @score
  end

  private

  def score_ones
    count = @dice.select { |die| die == 1 }
    if count.length == 5
      @score += 1200
    elsif count.length == 4
      @score += 1100
    elsif count.length == 3
      @score += 1000
    else
      @score += 100 * count.length
    end
    @dice.delete(1)
  end

  def score_fives
    count = @dice.select { |die| die == 5 }
    if count.length == 5
      @score += 600
    elsif count.length == 4
      @score += 550
    elsif count.length == 3
      @score += 500
    else
      @score += 50 * count.length
    end
    @dice.delete(5)
  end

  def score_others(num)
    count = @dice.select { |die| die == num }
    if count.length >= 3
      @score += num * 100
    end
    @dice.delete(num)
  end

end



class AboutScoringProject < Neo::Koan
  def test_score_of_an_empty_list_is_zero
    assert_equal 0, Greed.new([]).score
  end

  def test_score_of_a_single_roll_of_5_is_50
    assert_equal 50, Greed.new([5]).score
  end

  def test_score_of_a_single_roll_of_1_is_100
    assert_equal 100, Greed.new([1]).score
  end

  def test_score_of_multiple_1s_and_5s_is_the_sum_of_individual_scores
    assert_equal 300, Greed.new([1,5,5,1]).score
  end

  def test_score_of_single_2s_3s_4s_and_6s_are_zero
    assert_equal 0, Greed.new([2,3,4,6]).score
  end

  def test_score_of_a_triple_1_is_1000
    assert_equal 1000, Greed.new([1,1,1]).score
  end

  def test_score_of_other_triples_is_100x
    assert_equal 200, Greed.new([2,2,2]).score
    assert_equal 300, Greed.new([3,3,3]).score
    assert_equal 400, Greed.new([4,4,4]).score
    assert_equal 500, Greed.new([5,5,5]).score
    assert_equal 600, Greed.new([6,6,6]).score
  end

  def test_score_of_mixed_is_sum
    assert_equal 250, Greed.new([2,5,2,2,3]).score
    assert_equal 550, Greed.new([5,5,5,5]).score
    assert_equal 1100, Greed.new([1,1,1,1]).score
    assert_equal 1200, Greed.new([1,1,1,1,1]).score
    assert_equal 1150, Greed.new([1,1,1,5,1]).score
  end

end
