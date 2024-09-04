class Patient < ApplicationRecord
  DEFAULT_TREATMENT_SCHEDULE_DAYS = 3.freeze
  private_constant :DEFAULT_TREATMENT_SCHEDULE_DAYS

  has_many :injections

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :date_of_birth, presence: true
  validates :api_key, presence: true, uniqueness: true

  before_validation :assign_api_key, on: :create

  def adherence_score(treatment_schedule_days = DEFAULT_TREATMENT_SCHEDULE_DAYS)
    return unless persisted?

    calculate_adherence_score(treatment_schedule_days)
  end

  private

  def assign_api_key
    self.api_key = SecureRandom.hex(16)
  end

  def calculate_adherence_score(treatment_schedule_days)
    today = Date.today
    start_date = created_at.to_date

    expected_injections = calculate_expected_injections(start_date, today, treatment_schedule_days)
    actual_injections = injections.where(date: start_date..today).order(:date)

    on_time_injections = calculate_on_time_injections(actual_injections, treatment_schedule_days)

    return 0 if expected_injections.zero?

    adherence_percentage = (on_time_injections.to_f / expected_injections * 100).round
    [ adherence_percentage, 100 ].min
  end

  def calculate_expected_injections(start_date, end_date, interval)
    (end_date - start_date).to_i / interval + 1
  end

  def calculate_on_time_injections(actual_injections, interval)
    return 0 if actual_injections.empty?

    on_time_count = 0
    expected_date = actual_injections.first.date

    actual_injections.each do |injection|
      while expected_date <= injection.date
        if injection.date == expected_date
          on_time_count += 1
          break
        end
        expected_date += interval.days
      end
    end

    on_time_count
  end
end
