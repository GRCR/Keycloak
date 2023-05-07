<#import "template.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section = "title">
        ${msg("loginTitle",realm.name)}
    <#elseif section = "header">
        Select OTP Receive Type
    <#elseif section = "form">
        <form id="kc-otp-type-form" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post">

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
            
            <div class="${properties.kcFormGroupClass!}">
                <div id="kc-form-options" class="${properties.kcFormOptionsClass!}">
                    <div class="${properties.kcFormOptionsWrapperClass!}">

                    
                    
                    </div>
                </div>

                <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                    <div class="${properties.kcFormButtonsWrapperClass!}">
                        <input class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonLargeClass!}" name="login" id="kc-login" type="submit" value="${msg("doSubmit")}"/>
                    </div>
                </div>
            </div>
        </form>
    </#if>
</@layout.registrationLayout>