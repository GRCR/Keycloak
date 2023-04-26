<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false>
    <!DOCTYPE html>
    <html class="${properties.kcHtmlClass!}">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="robots" content="noindex, nofollow">
        <script src="https://cdn.tailwindcss.com"></script>
        <#if properties.meta?has_content>
            <#list properties.meta?split(' ') as meta>
            <meta name="${meta?split('==')[0]}" content="${meta?split('==')[1]}"/>
        </#list>
    </#if>
    <title>
${msg("loginTitle",(realm.displayName!''))}
</title>
    <link rel="icon" href="${url.resourcesPath}/img/favicon.ico" />
    <#if properties.stylesCommon?has_content>
        <#list properties.stylesCommon?split(' ') as style>
            <link href="${url.resourcesCommonPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
    <#if properties.styles?has_content>
        <#list properties.styles?split(' ') as style>
            <link href="${url.resourcesPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
    <#if properties.scripts?has_content>
        <#list properties.scripts?split(' ') as script>
            <script src="${url.resourcesPath}/${script}" type="text/javascript"></script>
        </#list>
    </#if>
    <#if scripts??>
        <#list scripts as script>
            <script src="${script}" type="text/javascript"></script>
        </#list>
    </#if>
</head>
<body class="${properties.kcBodyClass!}">
<div class="${properties.kcLoginClass!}">
    <div id="kc-header" class="${properties.kcHeaderClass!}">
        <div id="kc-header-wrapper"
             class="${properties.kcHeaderWrapperClass!}">
<#--  ${kcSanitize(msg("loginTitleHtml",(realm.displayNameHtml!'')))?no_esc}  -->
</div>
    </div>
    <div class="${properties.kcFormCardClass!}">
        <header class="${properties.kcFormHeaderClass!}">
            <#--  <#if realm.internationalizationEnabled  && locale.supported?size gt 1>
                <div class="${properties.kcLocaleMainClass!}" id="kc-locale">
                    <div id="kc-locale-wrapper" class="${properties.kcLocaleWrapperClass!}">
                        <div id="kc-locale-dropdown" class="${properties.kcLocaleDropDownClass!}">
                            <a href="#" id="kc-current-locale-link">
${locale.current}
</a>
                            <ul class="${properties.kcLocaleListClass!}">
                                <#list locale.supported as l>
                                    <li class="${properties.kcLocaleListItemClass!}">
                                        <a class="${properties.kcLocaleItemClass!}" href="${l.url}">
${l.label}
</a>
                                    </li>
                                </#list>
                            </ul>
                        </div>
                    </div>
                </div>
            </#if>  -->
        <#if !(auth?has_content && auth.showUsername() && !auth.showResetCredentials())>
            <#if displayRequiredFields>
                <div class="${properties.kcContentWrapperClass!}">
                    <div class="${properties.kcLabelWrapperClass!} subtitle">
                        <span class="subtitle"><span class="required">*</span>
${msg("requiredFields")}
</span>
                    </div>
                    <div class="col-md-10">
                        <h1 id="kc-page-title"><#nested "header"></h1>
                    </div>
                </div>
            <#else>
                <h1 id="kc-page-title"><#nested "header"></h1>
            </#if>
        <#else>
            <#if displayRequiredFields>
                <div class="${properties.kcContentWrapperClass!}">
                    <div class="${properties.kcLabelWrapperClass!} subtitle">
                        <span class="subtitle"><span class="required">*</span>
${msg("requiredFields")}
</span>
                    </div>
                    <div class="col-md-10">
                        <#nested "show-username">
                        <div id="kc-username" class="${properties.kcFormGroupClass!}">
                            <label id="kc-attempted-username">
${auth.attemptedUsername}
</label>
                            <a id="reset-login" href="${url.loginRestartFlowUrl}" aria-label="${msg("restartLoginTooltip")}">
                                <div class="kc-login-tooltip">
                                    <i class="${properties.kcResetFlowIcon!}"></i>
                                    <span class="kc-tooltip-text">
${msg("restartLoginTooltip")}
</span>
                                </div>
                            </a>
                        </div>
                    </div>
                </div>
            <#else>
                <#nested "show-username">
                <div id="kc-username" class="${properties.kcFormGroupClass!}">
                    <label id="kc-attempted-username">
${auth.attemptedUsername}
</label>
                    <a id="reset-login" href="${url.loginRestartFlowUrl}" aria-label="${msg("restartLoginTooltip")}">
                        <div class="kc-login-tooltip">
                            <i class="${properties.kcResetFlowIcon!}"></i>
                            <span class="kc-tooltip-text">
${msg("restartLoginTooltip")}
</span>
                        </div>
                    </a>
                </div>
            </#if>
        </#if>
      </header>
      <div id="kc-content">
        <div id="kc-content-wrapper">
          <#-- App-initiated actions should not see warning messages about the need to complete the action -->
          <#-- during login.                                                                               -->
          <#if displayMessage && message?has_content && (message.type != ' warning' || !isAppInitiatedAction??)>
                <!-- Toast Notification-->
                <#if message.type='success'>
                    <#assign alertColor="green">
                        <#elseif message.type='error'>
                            <#assign alertColor="red">
                                <#elseif message.type='warning'>
                                    <#assign alertColor="orange">
                                        <#elseif message.type='info'>
                                            <#assign alertColor="blue">
                </#if>
                <div id="alertDialog" class="flex items-center bg-${alertColor}-100 border border-${alertColor}-400 mt-3 py-2 px-3 shadow-md mb-2 rounded max-w-sm mx-auto" role="alert">
                    <!-- icons -->
                    <div class="text-white rounded-full bg-${alertColor}-400 mr-3 min-w-fit">
                        <#-- success -->
                            <#if message.type='success'>
                                <img src="${url.resourcesPath}/img/success.svg" alt="success">
                                <#-- warning -->
                                    <#elseif message.type='warning'>
                                        <img src="${url.resourcesPath}/img/warning.svg" alt="warning">
                                        <#-- info -->
                                            <#elseif message.type='info'>
                                                <img src="${url.resourcesPath}/img/info.svg" alt="info">
                                                <#-- error -->
                                                    <#elseif message.type='error'>
                                                        <img src="${url.resourcesPath}/img/error.svg" alt="error">
                            </#if>
                    </div>
                    <!-- message -->
                    <div class="text-${alertColor}-700 max-w-xs ">
                        ${kcSanitize(message.summary)?no_esc}
                    </div>
                    <button id="closeDialog" type="button" class="ml-auto text-gray-500 hover:text-gray-800 rounded-lg p-1.5  inline-flex h-8 w-8 text-gray-500  " aria-label="Close">
                        <span class="sr-only">Close</span>
                        <svg aria-hidden="true" class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
                            <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path>
                        </svg>
                    </button>
                </div>
                <#-- <div class="alert-${message.type} ${properties.kcAlertClass!} pf-m-<#if message.type = 'error'>danger<#else>
${message.type}
</#if>">
                    <div class="pf-c-alert__icon">
                        <#if message.type='success'><span class="${properties.kcFeedbackSuccessIcon!}"></span></#if>
                        <#if message.type='warning'><span class="${properties.kcFeedbackWarningIcon!}"></span></#if>
                        <#if message.type='error'><span class="${properties.kcFeedbackErrorIcon!}"></span></#if>
                        <#if message.type='info'><span class="${properties.kcFeedbackInfoIcon!}"></span></#if>
                    </div>
                    <span class="${properties.kcAlertTitleClass!}">
                        ${kcSanitize(message.summary)?no_esc}
                    </span>
                    </div> -->
        </#if>
        <#nested "form">
            <#if auth?has_content && auth.showTryAnotherWayLink()>
                <form id="kc-select-try-another-way-form" action="${url.loginAction}" method="post">
                    <div class="${properties.kcFormGroupClass!}">
                        <input type="hidden" name="tryAnotherWay" value="on" />
                        <a href="#" id="try-another-way"
                            onclick="document.forms['kc-select-try-another-way-form'].submit();return false;">
                            ${msg("doTryAnotherWay")}
                        </a>
                    </div>
                </form>
            </#if>
            <#nested "socialProviders">
                <#if displayInfo>
                    <div id="kc-info" class="${properties.kcSignUpClass!}">
                        <div id="kc-info-wrapper" class="${properties.kcInfoAreaWrapperClass!}">
                            <#nested "info">
                        </div>
                    </div>
                </#if>
                </div>
                </div>
                </div>
                </div>
                </body>

    </html>
</#macro>