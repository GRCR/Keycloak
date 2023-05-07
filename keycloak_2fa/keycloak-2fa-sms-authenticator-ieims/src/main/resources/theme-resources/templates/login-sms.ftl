<#import "template.ftl" as layout>
	<@layout.registrationLayout displayInfo=true; section>
		<#if section="header">
			${msg("smsAuthTitle",realm.displayName)}
			<#elseif section="form">
				<form id="kc-sms-code-login-form" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post">
					<div class="bg-gray-100 h-screen">
						<div class="flex items-center justify-between w-full bg-blue-700  p-2">
							<div class="flex items-center">
								<a href="#" class="flex items-center text-2xl font-semibold text-blue-700 dark:text-white">
									<img class="w-8 h-8 ml-2" src="https://flowbite.s3.amazonaws.com/blocks/marketing-ui/logo.svg"
										alt="logo" />
									<span class="text-base text-white ml-2 uppercase">
										${kcSanitize(msg("loginTitleHtml",(realm.displayNameHtml!'')))?no_esc} (${auth.attemptedUsername})
									</span>
								</a>
							</div>
							<div class="flex items-start">
								<#if realm.internationalizationEnabled && locale.supported?size gt 1>
									<div class="${properties.kcLocaleMainClass!}" id="kc-locale">
										<div id="kc-locale-wrapper" class="${properties.kcLocaleWrapperClass!}">
											<div id="kc-locale-dropdown" class="dropdown  hover:bg-blue-800 hover:rounded-lg mr-1 inline-block relative">
												<a href="#" id="kc-current-locale-link" class="text-white font-semibold py-2 px-4 inline-flex items-center">
													<#-- ${msg("changeLanguageTitle")}:-->
														${locale.current}
														<svg class="w-4 h-4 ml-2" aria-hidden="true" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
															<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
														</svg>
												</a>
												<div class="dropdown-menu absolute hidden z-10 hidden bg-white divide-y divide-gray-100 rounded-lg shadow w-24 dark:bg-gray-700">
													<ul class="py-2 text-sm text-gray-700 dark:text-gray-200">
														<#list locale.supported as l>
															<li class="${properties.kcLocaleListItemClass!}">
																<a class="<#if locale.current=l.label>pointer-events-none </#if> block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white" href="${l.url}">
																	${l.label}
																</a>
															</li>
														</#list>
													</ul>
												</div>
											</div>
										</div>
									</div>
								</#if>
							</div>
						</div>
						<div class="flex flex-col items-center justify-center px-6 py-8 mx-auto md:h-[85vh] lg:py-0">
							<div
								class="w-full bg-white rounded-lg shadow dark:border md:mt-0 sm:max-w-lg xl:p-0 dark:text-white dark:bg-gray-800 dark:border-gray-700">
								 <input tabindex="6" id="isInit" type="text" name="isInit" value=${isInit} class="hidden" />
								<div id="generateOtp" class="p-10 hidden ">
									<h3 class="text-black font-semibold mb-4">Get your OTP on:</h3>
									<div class="my-4 flex items-start space-x-12">
										<label class="flex">
											<input tabindex="1" id="otpSms" type="radio" name="selectedOtpType" value="SMS" class="focus:outline-black" <#if otpType="SMS"> checked </#if> />
											<span class="ml-2 text-sm font-medium  text-black">SMS</span>
										</label>
										<label class="flex ">
											<input tabindex="2" id="otpEmail" name="selectedOtpType" type="radio" value="E-mail" class="focus:outline-black" <#if otpType="E-mail"> checked </#if> />
											<span class="ml-2 text-sm font-medium  text-black">E-MAIL</span>
										</label>
									</div>
									<input tabindex="4" name="getOtp" id="getOtp" type="submit" value="${msg("getOtp")}"
										class="${properties.kcSubmitClass}" />
								</div>
								<div id="submitOtp" class="p-10">
									<div class="flex flex-col items-start w-full ">
										<h2 class="font-bold text-xl mb-3">Account Verification</h2>
										<h3 class="text-normal mb-2">Please enter the OTP Code you received.</h3>
										<div class="text-sm mb-4">The OTP code that was sent to <span class="font-bold">
												${otpTo}
											</span> and is <span class="font-bold">valid for ${otpValidity}
												minutes.</span> It
											might take a few
											seconds to recieve the Code.</div>
										<label for="otpCode" class="block my-2 text-sm font-bold text-gray-900 dark:text-white">
											${msg("smsAuthLabel")}
										</label>
										<input tabindex="3" id="otpCode" name="otpCode" class="${properties.kcOtpInputClass}"
											placeholder="Enter OTP" type="text" autofocus autocomplete="off" />
									</div>
									<div class="flex items-start justify-between mt-8 sm:max-w-lg">
										<div class="flex items-start flex-col w-1/2">
											<input tabindex="4" id="kc-form-buttons" type="submit" value="${msg("doContinue")}"
												class="${properties.kcSubmitClass}" />
										</div>
										<div class="flex items-start flex-col pl-2">
											<div id="resendId" class="text-sm <#if isInit="Yes"> hidden </#if>">If you don't receive any code,
												<input tabindex="5" id="resendOtp" name="resendOtp" type="submit" value="Click here" class="${properties.kcLinkClass} mt-2"/>
												to re-send a new
												code
											</div>
										</div>
									</div>
									<div id="tryAnotherWay" class="text-sm float-right py-4 <#if isInit="Yes"> hidden </#if>">
										<a href="#" class="${properties.kcLinkClass} mt-2">Try another way</a>
									</div>
								</div>
							</div>
							<a href="${url.loginRestartFlowUrl}" class="${properties.kcLinkClass} mt-8">
								${msg("restartLogin")}
							</a>
						</div>
					</div>
				</form>
				<#--  <#elseif section="info">
					${msg("smsAuthInstruction")}  -->
		</#if>
	</@layout.registrationLayout>