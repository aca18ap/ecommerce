class CalculateMetrics
  def initialize(visits, registrations)
    @visits = visits
    @registrations = registrations
    #@features = features
  end

  # Calculates the number of visits for each page
  def page_visits
    @visits.group_by { |visit| visit.path.itself }
           .map { |k, v| { 'page' => k, 'visits' => v.length } }
  end

  # Calculates number of visits at each hour
  def time_visits
  end

  # Calculates the number of registrations for each vocation
  def vocation_registrations
    @registrations.group_by { |registration| registration.vocation.itself }
                  .map { |k, v| { 'vocation' => k, 'registrations' => v.length } }
  end

  # Calculates the number of customer registrations by tier
  def tier_registrations
    @registrations.group_by { |registration| registration.vocation.itself }['Customer']
                  .group_by { |registration| registration.tier.itself }
                  .map { |k, v| { 'tier' => k, 'registrations' => v.length } }
  end

  # Calculates all pages visited using a specific session cookie in order of time to build a site path
  def session_flows
    @visits.group_by { |visit| visit.session_identifier.itself }
           .map { |k, v| { 'id' => k, 'flow' => v } }
  end

end