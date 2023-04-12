<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=true; section>
	<#if section = "header">
		${msg("smsAuthTitle",realm.displayName)}
	<#elseif section = "form">
		<form id="kc-sms-code-login-form" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post">

			<div class="${properties.kcFormGroupClass!}">
                <div class="${properties.kcInputWrapperClass!}">
                        
                    <input id="kc-otp-credential-1" class="${properties.kcLoginOTPListInputClass!}" type="radio" name="selectedOtpType" value="${'Email'}" checked="checked">
                        <label for="kc-otp-credential-1" class="${properties.kcLoginOTPListClass!}" tabindex="${1}">
                            <span class="${properties.kcLoginOTPListItemHeaderClass!}">
                                <span class="${properties.kcLoginOTPListItemIconBodyClass!}">
                                    <i class="${properties.kcLoginOTPListItemIconClass!}" aria-hidden="true"></i>
                                </span>
                                <span class="${properties.kcLoginOTPListItemTitleClass!}">${'Email'}</span>
                                </span>
                         </label>

                                                    
                         <input id="kc-otp-credential-2" class="${properties.kcLoginOTPListInputClass!}" type="radio" name="selectedOtpType" value="${'Mobile'}" >
                        <label for="kc-otp-credential-2" class="${properties.kcLoginOTPListClass!}" tabindex="${2}">
                            <span class="${properties.kcLoginOTPListItemHeaderClass!}">
                                <span class="${properties.kcLoginOTPListItemIconBodyClass!}">
                                  <i class="${properties.kcLoginOTPListItemIconClass!}" aria-hidden="true"></i>                                    </span>
                                <span class="${properties.kcLoginOTPListItemTitleClass!}">${'Mobile'}</span>
                                </span>
                        </label>
                    
                </div>
            </div>

			<input name="getOtp"
                class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonLargeClass!}"
                type="submit" value="${msg("getOtp")}"/>
			
			<div class="${properties.kcFormGroupClass!}">
				<div class="${properties.kcLabelWrapperClass!}">
					<label for="otpCode" class="${properties.kcLabelClass!}">${msg("smsAuthLabel")}</label>
				</div>
				<div class="${properties.kcInputWrapperClass!}">
					<input type="text" id="otpCode" name="otpCode" class="${properties.kcInputClass!}" autofocus/>
				</div>
			</div>

			<div class="${properties.kcFormGroupClass!} ${properties.kcFormSettingClass!}">
				<div id="kc-form-options" class="${properties.kcFormOptionsClass!}">
					<div class="${properties.kcFormOptionsWrapperClass!}">
						<span><a href="${url.loginUrl}">${kcSanitize(msg("backToLogin"))?no_esc}</a></span>
					</div>
				</div>

				<div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
					<input class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}" type="submit" value="${msg("doSubmit")}"/>
				</div>
			</div>

		</form>
	<#elseif section = "info" >
		${msg("smsAuthInstruction")}
	</#if>
</@layout.registrationLayout>
