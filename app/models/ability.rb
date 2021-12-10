# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, User
      can :manage, Review
      can :manage, Visit
      can :manage, Newsletter
      can :read, :all
      can :manage, Faq
      can :manage, :metrics
    elsif user.role == 'reporter'
      can :read, :all
      cannot :manage, Review
      can :manage, :metrics
      can :read, Faq
      can :create, Faq
      can :update, Faq
      can :answer, Faq
      can :like, Faq
      can :dislike, Faq
    else
      can :new, Review
      can :create, Review
      can :created, Review
      can :read, Faq, hidden: false
      can :read, Faq, hidden: nil
      can :create, Faq
      can :like, Faq
      can :dislike, Faq
      can :new, Newsletter
      can :create, Newsletter
      can :created, Newsletter
      cannot :manage, Visit
      cannot :all, MetricsController
    end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
