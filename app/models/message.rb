class Message < ApplicationRecord
    validates :key, presence: true, uniqueness: true, length: { minimum: 4 }
    validates :message, presence: true, length: { minimum: 6 }
    encrypts :email, :phone, :message
end
