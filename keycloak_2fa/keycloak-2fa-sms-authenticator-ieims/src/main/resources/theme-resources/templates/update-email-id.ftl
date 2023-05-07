<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('email_id'); section>
    <#if section = "header">
        ${msg("updateEmailTitle")}
    <#elseif section = "form">
			<h2>${msg("updateEmailHello",(username!''))}</h2>
			<p>${msg("updateEmailText")}</p>
			<form id="kc-email-update-form" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post">
				<div class="${properties.kcFormGroupClass!}">
					<div class="${properties.kcLabelWrapperClass!}">
						<label for="email_id"class="${properties.kcLabelClass!}">${msg("updateEmailFieldLabel")}</label>
					</div>
					<div class="${properties.kcInputWrapperClass!}">
						<input type="text" id="email_id" name="email_id" class="${properties.kcInputClass!}"
									 value="${email_id}" required aria-invalid="<#if messagesPerField.existsError('email_id')>true</#if>"/>
              <#if messagesPerField.existsError('email_id')>
								<span id="input-error-email-id" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
										${kcSanitize(messagesPerField.get('email_id'))?no_esc}
								</span>
              </#if>
					</div>
				</div>
				<div class="${properties.kcFormGroupClass!}">
					<div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
						<input class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}" type="submit" value="${msg("doSubmit")}"/>
					</div>
				</div>
			</form>
    </#if>
</@layout.registrationLayout>
