# CalculateMetrics calculates the points to represent on the
# D3 graphs represented on metrics/index
class CalculateMetrics
  def initialize(visits, registrations, shares)
    @visits = visits
    @registrations = registrations
    @shares = shares
  end

  # Calculates the number of visits for each page
  def page_visits
    return if @visits.nil? || @visits.empty?

    @visits.group_by { |visit| visit.path.itself }
           .map { |k, v| { 'page' => k, 'visits' => v.length } }
  end

  # Calculates the number of registrations for each vocation
  def vocation_registrations
    return if @registrations.nil? || @registrations.empty?

    @registrations.group_by { |registration| registration.vocation.itself }
                  .map { |k, v| { 'vocation' => k, 'registrations' => v.length } }
  end

  # Calculates the number of customer registrations by tier
  def tier_registrations
    return if @registrations.nil? || @registrations.empty?

    @registrations.group_by { |registration| registration.vocation.itself }['Customer']
                  .group_by { |registration| registration.tier.itself }
                  .map { |k, v| { 'tier' => k, 'registrations' => v.length } }
  end

  # Calculates all pages visited using a specific session cookie in order of time to build a site path
  def session_flows
    return if @visits.nil? || @visits.empty?

    @visits.group_by { |visit| visit.session_identifier.itself }
           .map { |k, v| { 'id' => k, 'flow' => v, 'registered' => flow_contains_registration(v) } }
  end

  # Calculates number of visits at each hour from the hour of the first visit
  def time_visits
    return if @visits.nil? || @visits.empty?

    time_visit_counts = {}

    # Need to create a dict of all hours between start and now to display 0 values correctly
    earliest_hour = DateTime.parse(@visits[0].from.to_s).change({ min: 0, sec: 0 })
    latest_hour = DateTime.now.change({ min: 0, sec: 0 })

    (earliest_hour.to_i..latest_hour.to_i).step(1.hour) do |date|
      time_visit_counts[date] = 0
    end

    @visits.each do |visit|
      time_visit_counts[DateTime.parse(visit.from.to_s).change({ min: 0, sec: 0 }).to_i] += 1
    end

    time_visit_counts.map { |k, v| { 'time' => k, 'visits' => v } }
  end

  # Calculates number of registrations at each hour, for each vocation (and total) from the hour of the first registration
  def time_registrations
    return if @registrations.nil? || @registrations.empty?

    # Need to create a dict of all hours between start and now to display 0 values correctly
    earliest_hour = DateTime.parse(@registrations[0].created_at.to_s).change({ min: 0, sec: 0 })
    time_regs = calculate_time_counts(@registrations, earliest_hour)
                  .map { |time, regs| { 'vocation' => 'Total', 'time' => time, 'registrations' => regs } }

    @registrations.group_by { |registration| registration.vocation.itself }.each do |k, v|
      time_regs.concat(calculate_time_counts(v, earliest_hour)
                         .map { |time, regs| { 'vocation' => k, 'time' => time, 'registrations' => regs } })
    end

    time_regs
  end

  def feature_shares
    return if @shares.nil? || @shares.empty?

    @shares.group_by { |share| share.feature.itself }
           .map { |k, v| { 'feature' => k, 'shares' => v.length } }
  end

  private

  # Calculates the number of registrations per hour for a subset of all registrations
  def calculate_time_counts(vocation_group, earliest_hour)
    time_registrations_counts = {}

    latest_hour = DateTime.now.change({ min: 0, sec: 0 })
    (earliest_hour.to_i..latest_hour.to_i).step(1.hour) do |date|
      time_registrations_counts[date] = 0
    end

    vocation_group.each do |registration|
      time_registrations_counts[DateTime.parse(registration.created_at.to_s).change({ min: 0, sec: 0 }).to_i] += 1
    end

    time_registrations_counts
  end

  # Identifies whether a session led to a registration by checking for /newsletters/# in path
  def flow_contains_registration(flow)
    flow.each do |f|
      return true if f.path.match(/.*\/newsletters\/[0-9]+/)
    end

    false
  end

  def record_share_feature(social)
    @share = Share.where(social: social)
    @share.count += 1
  end

end