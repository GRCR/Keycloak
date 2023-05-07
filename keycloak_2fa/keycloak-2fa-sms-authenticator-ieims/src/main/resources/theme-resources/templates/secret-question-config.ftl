<#import "template.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section = "title">
        ${msg("loginTitle",realm.name)}
    <#elseif section = "header">
        Setup Secret Question
    <#elseif section = "form">
        <form id="kc-totp-login-form" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post">
        
			<div class="${properties.kcFormGroupClass!}">

				<div class="${properties.kcLabelWrapperClass!}">
                    <label for="selectedQuestion" class="${properties.kcLabelClass!}">Select a secret question and enter answer</label>
                </div>

				<div class="${properties.kcInputWrapperClass!}">
                    <select class="form-control" id="selectedQuestion" name="selectedQuestion">
                        <#list Questions as question>
                            <option value="${question}" >${question}</option>
                        </#list>
                    </select>
                </div>

			 	<div class="${properties.kcInputWrapperClass!}">
                    <input id="secret_answer" name="secret_answer" type="text" placeholder="Enter your answer here" class="${properties.kcInputClass!}" />
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