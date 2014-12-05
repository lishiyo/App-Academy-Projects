class CatRentalRequest < ActiveRecord::Base
  validates :status, :start_date, :end_date, :cat_id, :presence => true
  validates :status, :inclusion => {in: ['PENDING', 'APPROVED','DENIED']}
  validates :requester, :presence => true
  validate :overlapping_cat_request
  belongs_to(:cat)

  belongs_to(
  :requester,
  :class_name => 'User',
  :foreign_key => :user_id,
  :primary_key => :id)

  after_initialize :set_pending


  # returns CatRentalRequest objects for same cat not myself
  # def sibling_requests
  #   self.cat.cat_rental_requests.where.not(id: self.id)
  # end

  # array of overlapping_requests of any status
  def overlapping_requests
    #(start_date - other.end_date) * (other.start_date - end_date) >= 0
    # overlapping_requests = []
    # sibling_requests.each do |sib|
    #   if (start_date - sib.end_date) * (sib.start_date - end_date) >= 0
    #     overlapping_requests << sib
    #   end
    # end
    # overlapping_requests
    date_range = (<<-SQL)
      (cat_rental_requests.start_date BETWEEN :start_date AND :end_date) OR
      (cat_rental_requests.end_date BETWEEN :start_date AND :end_date) OR
      (cat_rental_requests.start_date <= :start_date AND cat_rental_requests.end_date >= :end_date)
    SQL

    CatRentalRequest.where(cat_id: self.cat_id)
      .where(date_range, { start_date: self.start_date, end_date: self.end_date} )
      .where.not(id: self.id)
  end

  def overlapping_approved_requests
    overlapping_requests.select {|request| request.status == 'APPROVED'}
  end

  def overlapping_pending_requests
    overlapping_requests.select {|request| request.status == 'PENDING'}
  end

  def approve!
    self.class.transaction do
      self.status = 'APPROVED'
      overlapping_pending_requests.each do |denied_request|
        denied_request.status = 'DENIED'
        denied_request.save
      end
      self.save
    end
  end

  def deny!
    self.status = 'DENIED'
    self.save
  end

  private

  def set_pending
    self.status ||= 'PENDING'
  end

  def overlapping_cat_request
    unless overlapping_approved_requests.empty?
      errors[:start_date] << "is in existing date range"
    end
  end

end
