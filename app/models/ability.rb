# frozen_string_literal: true

# Handles access rights for different user groups throughout the system
class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:

    case user
    when Staff
      if user.admin?
        can :manage, [Staff, Customer, Business, Review, Visit, Newsletter, Faq, :metrics, Product, Material]
        can :read, :all
      elsif user.reporter?
        can :read, :metrics
        cannot :manage, Review
        can :create, [Faq, Product]
        can :read, Product
        can :like, Faq
        can :dislike, Faq
      end
    when Business
      can :create, Product
      can :read, Product
      can :read, Business
      can :read, Faq
      can :manage, :dashboard
    when Customer
      can :create, Product
      can :read, Product
      can :read, Business
      can :read, Faq
    else
      can :new, Review
      can :create, [Review, Faq, Newsletter]
      can :created, [Review, Newsletter]
      can :read, Faq, hidden: false
      can :read, Faq, hidden: nil
      can :like, Faq
      can :dislike, Faq
      can :new, Newsletter
      cannot :manage, Visit
      can :read, Product
      can :read, Business
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
