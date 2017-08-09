module Api
  class ContainerDeploymentsController < BaseController
    def create_resource(_type, _id, data)
      deployment = ContainerDeployment.new
      deployment.create_deployment(data, User.current_user)
    end

    def options
      # TODO: this service is rendering resources which (a) require
      # authentication (problematic for CORS compatibility), and (b)
      # are not being properly filtered by RBAC
      if [HttpHeaders::MIQ_TOKEN, HttpHeaders::AUTH_TOKEN, "HTTP_AUTHORIZATION"].any? { |header| request.headers.include?(header) }
        require_api_user_or_token
        render_options(:container_deployments, ContainerDeploymentService.new.all_data)
      else
        super
      end
    end
  end
end
