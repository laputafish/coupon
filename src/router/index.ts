import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from '../views/Home.vue'

import AppLayout from '@/views/layouts/AppLayout.vue'
import Dashboard from '@/views/pages/Dashboard.vue'
import Widgets from '@/views/pages/Widgets.vue'
import LayoutOptions from '@/views/pages/LayoutOptions.vue'
import Charts from '@/views/pages/Charts.vue'
import UIElements from '@/views/pages/UIElements.vue'
import Forms from '@/views/pages/Forms.vue'
import Tables from '@/views/pages/Tables.vue'

// Layout Options
import TopNavigation from '@/views/pages/layoutOptions/TopNavigation.vue'
import TopNavigationSidebar from '@/views/pages/layoutOptions/TopNavigationSidebar.vue'
import Boxed from '@/views/pages/layoutOptions/Boxed.vue'
import FixedSidebar from '@/views/pages/layoutOptions/FixedSidebar.vue'
import FixedNavbar from '@/views/pages/layoutOptions/FixedNavbar.vue'
import FixedFooter from '@/views/pages/layoutOptions/FixedFooter.vue'
import CollapsedSidebar from '@/views/pages/layoutOptions/CollapsedSidebar.vue'

// Charts
import ChartsJs from '@/views/pages/charts/ChartsJs.vue'
import Flot from '@/views/pages/charts/Flot.vue'
import Inline from '@/views/pages/charts/Inline.vue'

// UI Elements
import UIGeneral from '@/views/pages/ui_elements/UIGeneral.vue'
import UIIcons from '@/views/pages/ui_elements/UIIcons.vue'
import UIButtons from '@/views/pages/ui_elements/UIButtons.vue'
import UIModalsAlert from '@/views/pages/ui_elements/UIModalsAlert.vue'
import UINavbarTabs from '@/views/pages/ui_elements/UINavbarTabs.vue'
import UISliders from '@/views/pages/ui_elements/UISliders.vue'
import UITimeline from '@/views/pages/ui_elements/UITimeline.vue'
import UIRibbons from '@/views/pages/ui_elements/UIRibbons.vue'

// Forms
import FormsGeneralElements from '@/views/pages/forms/FormsGeneralElements.vue'
import FormsAdvancedElements from '@/views/pages/forms/FormsAdvancedElements.vue'
import FormsEditors from '@/views/pages/forms/FormsEditors.vue'
import FormsValidation from '@/views/pages/forms/FormsValidation.vue'

// Tables
import TablesSimpleTables from '@/views/pages/tables/TablesSimpleTables.vue'
import TablesDataTables from '@/views/pages/tables/TablesDataTables.vue'
import TablesJsGrid from '@/views/pages/tables/TablesJsGrid.vue'

// Application
import CouponCodes from '@/views/pages/coupon_codes/CouponCodes.vue'

Vue.use(VueRouter)

const routes = [
	{
		path: '/',
		name: 'Home',
		component: Home
	},
	{
		path: '/app',
		name: 'App',
		component: AppLayout,
		children: [
			{
				path: '/coupon_codes',
				name: 'coupon_codes',
				component: CouponCodes
			},
			{
				path: '/dashboard',
				name: 'dashboard',
				component: Dashboard
			},
			{
				path: '/widgets',
				name: 'widgets',
				component: Widgets
			},
			{
				path: '/layout_options',
				name: 'layout_options',
				component: LayoutOptions
			},
			{
				path: '/top_navigation',
				name: 'top_navigation',
				component: TopNavigation
			},
			{
				path: '/top_navigation_sidebar',
				name: 'top_navigation_sidebar',
				component: TopNavigationSidebar
			},
			{
				path: '/boxed',
				name: 'boxed',
				component: Boxed
			},
			{
				path: '/fixed_sidebar',
				name: 'fixed_sidebar',
				component: FixedSidebar
			},
			{
				path: '/fixed_navbar',
				name: 'fixed_navbar',
				component: FixedNavbar
			},
			{
				path: '/fixed_footer',
				name: 'fixed_footer',
				component: FixedFooter
			},
			{
				path: '/collapsed_sidebar',
				name: 'collapsed_sidebar',
				component: CollapsedSidebar
			},
			{
				path: '/charts',
				name: 'charts',
				component: Charts,
				children: [
					{
						path: '/charts_js',
						name: 'charts_js',
						component: ChartsJs
					},
					{
						path: '/flot',
						name: 'flot',
						component: Flot
					},
					{
						path: '/inline',
						name: 'inline',
						component: Inline
					}
				]
			},
			{
				path: '/ui_elements',
				name: 'ui_elements',
				component: UIElements,
				children: [
					{
						path: '/ui_general',
						name: 'general',
						component: UIGeneral
					},
					{
						path: '/ui_icons',
						name: 'icons',
						component: UIIcons
					},
					{
						path: '/ui_buttons',
						name: 'buttons',
						component: UIButtons
					},
					{
						path: '/ui_sliders',
						name: 'sliders',
						component: UISliders
					},
					{
						path: '/ui_modal_alerts',
						name: 'modals_alerts',
						component: UIModalsAlert
					},
					{
						path: '/ui_navbar_tabs',
						name: 'navbar_tabs',
						component: UINavbarTabs
					},
					{
						path: '/ui_timeline',
						name: 'timeline',
						component: UITimeline
					},
					{
						path: '/ui_ribbons',
						name: 'ribbons',
						component: UIRibbons
					},
					{
						path: '/forms',
						name: 'forms',
						component: Forms,
						children: [
							{
								path: 'general_elements',
								name: 'general_elements',
								component: FormsGeneralElements
							},
							{
								path: 'advanced_elements',
								name: 'advanced_elements',
								component: FormsAdvancedElements
							},
							{
								path: 'editors',
								name: 'editors',
								component: FormsEditors
							},
							{
								path: 'validation',
								name: 'validation',
								component: FormsValidation
							}
						]
					},
					{
						path: '/tables',
						name: 'tables',
						component: Tables,
						children: [
							{
								path: 'simple_tables',
								name: 'simple_tables',
								component: TablesSimpleTables
							},
							{
								path: 'datatables',
								name: 'datatables',
								component: TablesDataTables
							},
							{
								path: 'js_grid',
								name: 'js_grid',
								component: TablesJsGrid
							},
						]
					}
				]
			}
		]
	},
	{
		path: '/about',
		name: 'About',
		// route level code-splitting
		// this generates a separate chunk (about.[hash].js) for this route
		// which is lazy-loaded when the route is visited.
		component: () => import(/* webpackChunkName: "about" */ '../views/About.vue')
	}
]

const router = new VueRouter({
	mode: 'history',
	base: process.env.BASE_URL,
	routes
})

export default router
