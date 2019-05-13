class AlreadySatisfiedError < StandardError
end

class NotSatisfiedError < StandardError
end

class CantUnsatisfyExpiredOffer < StandardError
end

class CantUnsatisfyOldOffer < StandardError
end

class CantSatisfyOldOffer < StandardError
end
