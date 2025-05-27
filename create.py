import os

def create_directory(path):
    """Create a directory if it doesn't exist"""
    os.makedirs(path, exist_ok=True)

def create_file(path):
    """Create an empty file if it doesn't exist"""
    if not os.path.exists(path):
        with open(path, 'w') as f:
            pass

def create_project_structure():
    # Base directory
    base_dir = 'lib'
    create_directory(base_dir)
    
    # app directory
    app_dir = os.path.join(base_dir, 'app')
    create_directory(app_dir)
    for file in ['app.dart', 'theme.dart', 'router.dart']:
        create_file(os.path.join(app_dir, file))
    
    # core directory and subdirectories
    core_dir = os.path.join(base_dir, 'core')
    create_directory(core_dir)
    
    # core/constants
    constants_dir = os.path.join(core_dir, 'constants')
    create_directory(constants_dir)
    for file in ['api_constants.dart', 'app_constants.dart', 'asset_constants.dart', 'storage_keys.dart']:
        create_file(os.path.join(constants_dir, file))
    
    # core/enums
    enums_dir = os.path.join(core_dir, 'enums')
    create_directory(enums_dir)
    for file in ['transaction_type.dart', 'transaction_status.dart', 'notification_type.dart',
                 'document_type.dart', 'task_type.dart', 'payment_gateway.dart']:
        create_file(os.path.join(enums_dir, file))
    
    # core/exceptions
    exceptions_dir = os.path.join(core_dir, 'exceptions')
    create_directory(exceptions_dir)
    for file in ['api_exception.dart', 'auth_exception.dart', 'app_exception.dart']:
        create_file(os.path.join(exceptions_dir, file))
    
    # core/services
    services_dir = os.path.join(core_dir, 'services')
    create_directory(services_dir)
    for file in ['api_service.dart', 'auth_service.dart', 'storage_service.dart',
                 'biometric_service.dart', 'device_service.dart', 'notification_service.dart']:
        create_file(os.path.join(services_dir, file))
    
    # core/utils
    utils_dir = os.path.join(core_dir, 'utils')
    create_directory(utils_dir)
    for file in ['validators.dart', 'formatters.dart', 'snackbar_utils.dart', 'navigation_utils.dart']:
        create_file(os.path.join(utils_dir, file))
    
    # features directory
    features_dir = os.path.join(base_dir, 'features')
    create_directory(features_dir)
    
    # features/auth
    auth_dir = os.path.join(features_dir, 'auth')
    create_directory(auth_dir)
    for subdir in ['models', 'providers', 'repositories', 'screens', 'widgets']:
        create_directory(os.path.join(auth_dir, subdir))
    
    create_file(os.path.join(auth_dir, 'models', 'auth_request.dart'))
    create_file(os.path.join(auth_dir, 'providers', 'auth_provider.dart'))
    create_file(os.path.join(auth_dir, 'repositories', 'auth_repository.dart'))
    for file in ['login_screen.dart', 'register_screen.dart', 'verify_email_screen.dart', 'forgot_password_screen.dart']:
        create_file(os.path.join(auth_dir, 'screens', file))
    for file in ['auth_button.dart', 'auth_text_field.dart']:
        create_file(os.path.join(auth_dir, 'widgets', file))
    
    # features/home
    home_dir = os.path.join(features_dir, 'home')
    create_directory(home_dir)
    for subdir in ['providers', 'repositories', 'screens', 'widgets']:
        create_directory(os.path.join(home_dir, subdir))
    
    create_file(os.path.join(home_dir, 'providers', 'home_provider.dart'))
    create_file(os.path.join(home_dir, 'repositories', 'home_repository.dart'))
    for file in ['home_screen.dart', 'main_screen.dart']:
        create_file(os.path.join(home_dir, 'screens', file))
    for file in ['balance_card.dart', 'profit_chart.dart', 'quick_actions.dart', 'recent_transactions.dart']:
        create_file(os.path.join(home_dir, 'widgets', file))
    
    # features/plans
    plans_dir = os.path.join(features_dir, 'plans')
    create_directory(plans_dir)
    for subdir in ['models', 'providers', 'repositories', 'screens', 'widgets']:
        create_directory(os.path.join(plans_dir, subdir))
    
    create_file(os.path.join(plans_dir, 'models', 'plan_purchase_request.dart'))
    create_file(os.path.join(plans_dir, 'providers', 'plans_provider.dart'))
    create_file(os.path.join(plans_dir, 'repositories', 'plans_repository.dart'))
    for file in ['plans_screen.dart', 'plan_details_screen.dart']:
        create_file(os.path.join(plans_dir, 'screens', file))
    for file in ['plan_card.dart', 'plan_comparison.dart', 'purchase_plan_dialog.dart']:
        create_file(os.path.join(plans_dir, 'widgets', file))
    
    # features/wallet
    wallet_dir = os.path.join(features_dir, 'wallet')
    create_directory(wallet_dir)
    for subdir in ['models', 'providers', 'repositories', 'screens', 'widgets']:
        create_directory(os.path.join(wallet_dir, subdir))
    
    for file in ['deposit_request.dart', 'withdrawal_request.dart']:
        create_file(os.path.join(wallet_dir, 'models', file))
    for file in ['wallet_provider.dart', 'deposit_provider.dart', 'withdrawal_provider.dart']:
        create_file(os.path.join(wallet_dir, 'providers', file))
    for file in ['wallet_repository.dart', 'deposit_repository.dart', 'withdrawal_repository.dart']:
        create_file(os.path.join(wallet_dir, 'repositories', file))
    for file in ['wallet_screen.dart', 'deposit_screen.dart', 'withdrawal_screen.dart', 'transactions_screen.dart']:
        create_file(os.path.join(wallet_dir, 'screens', file))
    for file in ['payment_method_card.dart', 'transaction_list_item.dart', 'withdrawal_status_card.dart']:
        create_file(os.path.join(wallet_dir, 'widgets', file))
    
    # features/tasks
    tasks_dir = os.path.join(features_dir, 'tasks')
    create_directory(tasks_dir)
    for subdir in ['providers', 'repositories', 'screens', 'widgets']:
        create_directory(os.path.join(tasks_dir, subdir))
    
    create_file(os.path.join(tasks_dir, 'providers', 'tasks_provider.dart'))
    create_file(os.path.join(tasks_dir, 'repositories', 'tasks_repository.dart'))
    create_file(os.path.join(tasks_dir, 'screens', 'tasks_screen.dart'))
    create_file(os.path.join(tasks_dir, 'widgets', 'task_card.dart'))
    
    # features/referrals
    referrals_dir = os.path.join(features_dir, 'referrals')
    create_directory(referrals_dir)
    for subdir in ['providers', 'repositories', 'screens', 'widgets']:
        create_directory(os.path.join(referrals_dir, subdir))
    
    create_file(os.path.join(referrals_dir, 'providers', 'referrals_provider.dart'))
    create_file(os.path.join(referrals_dir, 'repositories', 'referrals_repository.dart'))
    create_file(os.path.join(referrals_dir, 'screens', 'referrals_screen.dart'))
    for file in ['referral_card.dart', 'share_referral_dialog.dart']:
        create_file(os.path.join(referrals_dir, 'widgets', file))
    
    # features/kyc
    kyc_dir = os.path.join(features_dir, 'kyc')
    create_directory(kyc_dir)
    for subdir in ['models', 'providers', 'repositories', 'screens', 'widgets']:
        create_directory(os.path.join(kyc_dir, subdir))
    
    create_file(os.path.join(kyc_dir, 'models', 'kyc_submission.dart'))
    create_file(os.path.join(kyc_dir, 'providers', 'kyc_provider.dart'))
    create_file(os.path.join(kyc_dir, 'repositories', 'kyc_repository.dart'))
    for file in ['kyc_screen.dart', 'document_upload_screen.dart']:
        create_file(os.path.join(kyc_dir, 'screens', file))
    for file in ['document_type_selector.dart', 'document_preview.dart']:
        create_file(os.path.join(kyc_dir, 'widgets', file))
    
    # features/profile
    profile_dir = os.path.join(features_dir, 'profile')
    create_directory(profile_dir)
    for subdir in ['providers', 'repositories', 'screens', 'widgets']:
        create_directory(os.path.join(profile_dir, subdir))
    
    create_file(os.path.join(profile_dir, 'providers', 'profile_provider.dart'))
    create_file(os.path.join(profile_dir, 'repositories', 'profile_repository.dart'))
    for file in ['profile_screen.dart', 'edit_profile_screen.dart', 'change_password_screen.dart']:
        create_file(os.path.join(profile_dir, 'screens', file))
    for file in ['profile_header.dart', 'settings_tile.dart']:
        create_file(os.path.join(profile_dir, 'widgets', file))
    
    # features/news
    news_dir = os.path.join(features_dir, 'news')
    create_directory(news_dir)
    for subdir in ['providers', 'repositories', 'screens', 'widgets']:
        create_directory(os.path.join(news_dir, subdir))
    
    create_file(os.path.join(news_dir, 'providers', 'news_provider.dart'))
    create_file(os.path.join(news_dir, 'repositories', 'news_repository.dart'))
    for file in ['news_screen.dart', 'news_detail_screen.dart']:
        create_file(os.path.join(news_dir, 'screens', file))
    create_file(os.path.join(news_dir, 'widgets', 'news_card.dart'))
    
    # features/notifications
    notifications_dir = os.path.join(features_dir, 'notifications')
    create_directory(notifications_dir)
    for subdir in ['providers', 'repositories', 'screens', 'widgets']:
        create_directory(os.path.join(notifications_dir, subdir))
    
    create_file(os.path.join(notifications_dir, 'providers', 'notifications_provider.dart'))
    create_file(os.path.join(notifications_dir, 'repositories', 'notifications_repository.dart'))
    create_file(os.path.join(notifications_dir, 'screens', 'notifications_screen.dart'))
    create_file(os.path.join(notifications_dir, 'widgets', 'notification_item.dart'))
    
    # models directory
    models_dir = os.path.join(base_dir, 'models')
    create_directory(models_dir)
    for file in ['user.dart', 'transaction.dart', 'plan.dart', 'task.dart', 'referral.dart',
                 'kyc_document.dart', 'notification.dart', 'news.dart', 'payment.dart', 'withdrawal.dart']:
        create_file(os.path.join(models_dir, file))
    
    # providers directory
    providers_dir = os.path.join(base_dir, 'providers')
    create_directory(providers_dir)
    for file in ['global_providers.dart', 'app_state_provider.dart']:
        create_file(os.path.join(providers_dir, file))
    
    # repositories directory
    repositories_dir = os.path.join(base_dir, 'repositories')
    create_directory(repositories_dir)
    create_file(os.path.join(repositories_dir, 'base_repository.dart'))
    
    # shared/widgets directory
    shared_widgets_dir = os.path.join(base_dir, 'shared', 'widgets')
    create_directory(shared_widgets_dir)
    for file in ['app_bar.dart', 'loading_button.dart', 'error_widget.dart',
                 'empty_state_widget.dart', 'custom_text_field.dart', 'bottom_sheet.dart', 'animated_loader.dart']:
        create_file(os.path.join(shared_widgets_dir, file))
    
    # main.dart
    create_file(os.path.join(base_dir, 'main.dart'))

if __name__ == '__main__':
    create_project_structure()
    print("Project structure created successfully!")
